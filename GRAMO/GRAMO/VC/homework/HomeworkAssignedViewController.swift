//
//  homeworkAssignedVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

class HomeworkAssignedViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var majorButton: UIButton!
    @IBOutlet weak var selectDeadLineTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var httpClient = HTTPClient()
    var model : [HwContent] = [HwContent]()
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        getContent(id: id)
        // Do any additional setup after loading the view.
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
        httpClient.get(url: HomeworkAPI.getHomeworkContent(id).path(), params: nil, header: Header.token.header()).responseJSON {(res) in
            switch res.response?.statusCode {
            case 200 :
                do{
                    let data = res.data
                    let model = try JSONDecoder().decode(HwContent.self, from: data!)
                    
                    self.selectDeadLineTextField.text = self.formatEndDate(model.endDate)
                    self.dateLabel.text = self.formatStartDate(model.startDate)
                    self.nameLabel.text = model.teacherName
                    self.majorButton.setTitle(self.setMajor(model.major), for: .normal)
                    self.titleTextField.text = model.title
                    self.contentTextView.text = model.description
                }
                catch{
                    print("error: \(error)")
                }
                
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.")
            case 401 : print("401 - Unauthorized")
                self.showAlert(title: "허가되지 않았습니다.")
            case 404 : print("404 - NOT FOUND")
                self.showAlert(title: "오류가 발생했습니다.")
            default : print(res.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.")
            }
        }
        
    }
    
    func submitHw(homeworkId : Int) {
        httpClient.patch(url: HomeworkAPI.submitHomework(id).path(), params:  ["homeworkId":homeworkId], header: Header.token.header()).responseJSON {(res) in
            switch res.response?.statusCode {
            case 201 :
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.")
            case 401 : print("401 - Unauthorized")
                self.showAlert(title: "허가되지 않았습니다.")
            case 404 : print("404 - NOT FOUND")
                self.showAlert(title: "오류가 발생했습니다.")
            default : print(res.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.")
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
