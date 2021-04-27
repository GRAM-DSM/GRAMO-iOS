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
    
    let httpClient = HTTPClient()
    var infoList = [InfoList]()
    
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
        
        placeholderSetting()
        textViewDidBeginEditing(infoTitle)
        textViewDidBeginEditing(infoDetail)
        textViewDidEndEditing(infoTitle)
        textViewDidEndEditing(infoDetail)
        
        
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
        createNotice()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func createNotice() {
        print("포스트 호출됨")
        httpClient.post(NetworkingAPI.createNotice(infoTitle.text, infoDetail.text)).responseJSON{(res) in
            switch res.response?.statusCode{
            case 200:
                do {
                    print("SUCCESS")
                    self.navigationController?.popViewController(animated: true)
                }
                catch {
                    print("error\(error)")
                }
                
            default: print("Create")
                print(res.response?.statusCode)
                
            }
        }
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
    
    func setNavigationBar(){
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
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
