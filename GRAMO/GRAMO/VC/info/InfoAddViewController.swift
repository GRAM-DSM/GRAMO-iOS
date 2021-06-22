//
//  infoAddVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

final class InfoAddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak private var nameLabel : UILabel!
    @IBOutlet weak private var dateLabel : UILabel!
    @IBOutlet weak private var infoTitle: UITextField!
    @IBOutlet weak private var infoDetail: UITextView!
    
    let httpClient = HTTPClient()
    var infoList = [InfoList]()
    private var signInModel: SignIn!
    
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        if dateLabel.adjustsFontSizeToFitWidth == false {
            dateLabel.adjustsFontSizeToFitWidth = true
        }
        
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = date.string(from: Date())
        dateLabel.text = currentDate
        
        nameLabel.text = UserDefaults.standard.object(forKey: "nickname") as? String
        
        placeholderSetting()
        
        infoTitle.delegate = self
        infoDetail.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_ :)), name: UITextField.textDidChangeNotification, object: infoTitle)
    }
    
    @IBAction private func cancel(_ sender : UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func createNoticeButton(_ sender : UIBarButtonItem){
        if infoTitle.text == nil || infoDetail.textColor == UIColor.lightGray {
            showAlert(title: "제목 또는 내용을 입력해주세요.", message: nil)
        }
        
        //        let title = infoTitle.text!
        //        let detail = infoDetail.text!
        //        let date = dateLabel.text!
        //
        //        let item : InfoList = InfoList(writer: "장서영", date: date, infotTitle: title, infoDetail: detail)
        //
        //        infoList.append(item)
        createNotice(title: infoTitle.text!, content: infoDetail.text!)
    }
    
    private func createNotice(title: String, content: String) {
        httpClient.post(url: NoticeAPI.createNotice.path(), params: ["title":title, "content":content], header: Header.token.header()).responseJSON{[unowned self](res) in
            switch res.response?.statusCode{
            case 201:
                sleep(UInt32(0.1))
                navigationController?.popViewController(animated: true)
                
            default: print(res.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    private func placeholderSetting() {
        infoDetail.delegate = self
        infoDetail.text = "내용을 입력하세요"
        infoDetail.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == infoDetail{
                textView.text = "내용을 입력하세요"
                textView.textColor = UIColor.lightGray
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 1000
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                
                if text.count > 50 {
                    textField.resignFirstResponder()
                }
                
                if text.count >= 50 {
                    let index = text.index(text.startIndex, offsetBy: 50)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
            }
        }
    }
}
