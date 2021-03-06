//
//  infoAddVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

class infoAddVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var infoTitle: UITextView!
    @IBOutlet weak var infoDetail: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderSetting()
        textViewDidBeginEditing(infoTitle)
        textViewDidBeginEditing(infoDetail)
        textViewDidEndEditing(infoTitle)
        textViewDidEndEditing(infoDetail)
        
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = date.string(from: Date())
        dateLabel.text = currentDate
        
        if dateLabel.adjustsFontSizeToFitWidth == false {
            dateLabel.adjustsFontSizeToFitWidth = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender : UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plus(_ sender : UIBarButtonItem){
        if infoTitle.textColor == UIColor.lightGray && infoDetail.textColor == UIColor.lightGray {
            let alert = UIAlertController(title: "제목 또는 내용을 입력해주세요.", message: nil, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        let title = infoTitle.text!
        let detail = infoDetail.text!
        let date = dateLabel.text!
        
        let item : InfoList = InfoList(writer: "장서영", date: date, infotTitle: title, infoDetail: detail)
        
        infoList.append(item)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func placeholderSetting() {
        infoTitle.delegate = self
        infoDetail.delegate = self
        infoTitle.text = "제목을 입력하세요"
        infoDetail.text = "내용을 입력하세요"
        infoTitle.textColor = UIColor.lightGray
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
            if textView == infoTitle{
                textView.text = "제목을 입력하세요"
                textView.textColor = UIColor.lightGray
            }
            if textView == infoDetail{
                textView.text = "내용을 입력하세요"
                textView.textColor = UIColor.lightGray
            }
           
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
