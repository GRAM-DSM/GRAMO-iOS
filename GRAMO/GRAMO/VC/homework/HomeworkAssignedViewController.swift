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
    }
    
    @IBAction func backButton1(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton2(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitButton(_ sender: UIButton){
        submitHw(homeworkId: id)
    }
    
    func getContent(id: Int) {
        httpClient.get(url: HomeworkAPI.getHomeworkContent(id).path(), params: nil, header: Header.token.header()).responseJSON { [self](res) in
            switch res.response?.statusCode {
            case 200 :
                do{
                    let data = res.data
                    let model = try JSONDecoder().decode(HwContent.self, from: data!)
                    
                    selectDeadLineTextField.text = formatEndDate(model.endDate)
                    dateLabel.text = formatStartDate(model.startDate)
                    nameLabel.text = model.teacherName
                    majorButton.setTitle(setMajor(model.major), for: .normal)
                    titleTextField.text = model.title
                    contentTextView.text = model.description
                }
                catch{
                    print("error: \(error)")
                }
                
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.", message: nil)
            case 401 : print("401 - Unauthorized")
                self.showAlert(title: "허가되지 않았습니다.", message: nil)
            case 404 : print("404 - NOT FOUND")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(res.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
        
    }
    
    func submitHw(homeworkId : Int) {
        httpClient.patch(url: HomeworkAPI.submitHomework(id).path(), params:  ["homeworkId":homeworkId], header: Header.token.header()).responseJSON {(res) in
            switch res.response?.statusCode {
            case 201 :
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.", message: nil)
            case 401 : print("401 - Unauthorized")
                self.showAlert(title: "허가되지 않았습니다.", message: nil)
            case 404 : print("404 - NOT FOUND")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(res.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
}
