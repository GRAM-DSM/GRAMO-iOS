//
//  homeworkAllocatorVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

final class HomeworkOrderedViewController: UIViewController {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var majorButton: UIButton!
    @IBOutlet weak private var selectDeadLineTextField: UITextField!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var contentTextView: UITextView!
    @IBOutlet weak private var returnButton: UIButton!
    @IBOutlet weak private var doneButton: UIButton!
    
    var httpClient = HTTPClient()
    var model: [HwContent] = [HwContent]()
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
    
    @IBAction func deleteContent(_ sender: UIBarButtonItem){
        showDeleteAlert(title: "숙제를 삭제하시겠습니까?", action: {[self] (action) in deleteHomework(deleteId: id)}, message: "되돌리기는 불가능합니다.")
    }
    
    @IBAction func returnButton(_ sender: UIButton){
        showDeleteAlert(title: "숙제를 반환하시겠습니까?", action: {[self] (action) in rejectedHomework(homeworkId: id)}, message: "반환된 숙제는 숙제 할당자의 할당됨으로 되돌아갑니다.")
    }
    
    @IBAction func doneButton(_ sender: UIButton){
        showDeleteAlert(title: "숙제를 완료하시겠습니까?", action: {[self] (action) in deleteHomework(deleteId: id)}, message: "완료된 숙제는 삭제됩니다.")
    }
    
    
    func getContent(id: Int) {
        httpClient.get(url: HomeworkAPI.getHomeworkContent(id).path(), params: nil, header: Header.token.header()).responseJSON { [self](res) in
            switch res.response?.statusCode {
            case 200 :
                do{
                    let data = res.data
                    let model = try JSONDecoder().decode(HwContent.self, from: data!)
                    
                    selectDeadLineTextField.text = formatStartDate(model.endDate)
                    dateLabel.text = formatEndDate(model.startDate)
                    nameLabel.text = model.studentName
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
    
    
    func deleteHomework(deleteId : Int) {
        httpClient.delete(url: HomeworkAPI.deleteHomework(deleteId).path(), params: ["deleteId":deleteId], header: Header.token.header()).responseJSON {(res) in
            switch res.response?.statusCode {
            case 200 :
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
    
    func rejectedHomework(homeworkId: Int){
        httpClient.patch(url: HomeworkAPI.rejectHomework(homeworkId).path(), params: ["homeworkId":homeworkId], header: Header.token.header()).responseJSON {(res) in
            switch res.response?.statusCode {
            case 201 :
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.", message: nil)
            case 401 : print("401 - Unauthorized")
                self.showAlert(title: "허가되지 않았습니다.", message: nil)
            case 404 : print("404 - NOT FOUND")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            case 409 : print("409 - 권한이 없습니다.")
                self.showAlert(title: "숙제가 아직 제출되지 않았습니다.", message: "숙제를 반환할 권한이 없습니다.")
            default : print(res.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
}
