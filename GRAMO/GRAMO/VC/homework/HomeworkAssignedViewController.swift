//
//  homeworkAssignedVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

final class HomeworkAssignedViewController: UIViewController {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var majorButton: UIButton!
    @IBOutlet weak private var selectDeadLineTextField: UITextField!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var contentTextView: UITextView!
    @IBOutlet weak private var submitButton: UIButton!
    
    var httpClient = HTTPClient()
    var model : [HwContent] = [HwContent]()
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        getContent(id: id)
        
//        nameLabel.text = "이가영"
//        dateLabel.text = "2021년 11월 14일"
//        contentTextView.text = "RxSwift 공부해오기"
//        titleTextField.text = "11월 둘째주 숙제"
//        selectDeadLineTextField.text = "2021년 11월 21일"
//        majorButton.setTitle("iOS", for: .normal)
    }
    
    @IBAction private func backButton1(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func backButton2(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction private func submitButton(_ sender: UIButton){
        submitHw(homeworkId: id)
    }
    
    private func getContent(id: Int) {
        httpClient.get(url: HomeworkAPI.getHomeworkContent(id).path(), params: nil, header: Header.accessToken.header()).responseJSON { [unowned self](res) in
            switch res.response?.statusCode {
            case 200 :
                
                let model = try? JSONDecoder().decode(HwContent.self, from: res.data!)
                selectDeadLineTextField.text = formatEndDate(model!.endDate)
                dateLabel.text = formatStartDate(model!.startDate)
                nameLabel.text = model!.teacherName
                majorButton.setTitle(setMajor(model!.major), for: .normal)
                titleTextField.text = model!.title
                contentTextView.text = model!.description
                
            case 400 :
                showAlert(title: "잘못된 요청입니다.", message: nil)
            
            case 401:
                print("401 - getHomeworkContent")
                tokenRefresh()
                
            case 404 :
                showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(res.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
        
    }
    
    private func submitHw(homeworkId : Int) {
        httpClient.patch(url: HomeworkAPI.submitHomework(id).path(), params:  ["homeworkId":homeworkId], header: Header.accessToken.header()).responseJSON {[unowned self](res) in
            print(res.response?.statusCode)
            switch res.response?.statusCode {
            case 201 :
                navigationController?.popViewController(animated: true)
            case 400 :
                showAlert(title: "잘못된 요청입니다.", message: nil)
            
            case 401:
                print("401 - submitHomework")
                tokenRefresh()
                
            case 404 :
                showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(res.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
}
