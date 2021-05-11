//
//  homeworkAllocatorVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

class HomeworkOrderedViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var majorButton: UIButton!
    @IBOutlet weak var selectDeadLineTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var httpClient = HTTPClient()
    var model: [HwContent] = [HwContent]()
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        getContent(id)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton1(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton2(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteContent(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: "숙제를 삭제하시겠습니까?", message: "되돌리기는 불가능합니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "예", style: .destructive) {[self] (action) in self.deleteHomework(id)}
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func returnButton(_ sender: UIButton){
        let alert = UIAlertController(title: "숙제를 반환하시겠습니까?", message: "반환된 숙제는 숙제 할당자의 할당됨으로 되돌아갑니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let rejectAction = UIAlertAction(title: "예", style: .default, handler: {[self] (action) in self.rejectedHomework(id)})
        
        alert.addAction(cancelAction)
        alert.addAction(rejectAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: UIButton){
        let alert = UIAlertController(title: "숙제를 완료하시겠습니까?", message: "완료된 숙제는 삭제됩니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "예", style: .destructive, handler: {[self] (action) in self.deleteHomework(id)})
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getContent(_ id: Int) {
        httpClient.get(NetworkingAPI.getHomeworkContent(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 200 :
                do{
                    let data = res.data
                    let model = try JSONDecoder().decode(HwContent.self, from: data!)
                    
                    self.selectDeadLineTextField.text = self.formatStartDate(model.endDate)
                    self.dateLabel.text = self.formatEndDate(model.startDate)
                    self.nameLabel.text = model.studentName
                    self.majorButton.setTitle(self.setMajor(model.major), for: .normal)
                    self.titleTextField.text = model.title
                    self.contentTextView.text = model.description
                }
                catch{
                    print("error: \(error)")
                }
                
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            default : print(res.response?.statusCode)
                
            }
        }
        
    }
    
    
    func deleteHomework(_ id : Int) {
        httpClient.delete(NetworkingAPI.deleteHomework(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 200 :
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            default : print(res.response?.statusCode)
            }
        }
    }
    
    func rejectedHomework(_ id: Int){
        httpClient.patch(NetworkingAPI.rejectHomework(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 201 :
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            case 409 : print("409 - 권한이 없습니다.")
                let alert = UIAlertController(title: "숙제가 아직 제출되지 않았습니다.", message: "숙제를 반환할 권한이 없습니다.", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            default : print(res.response?.statusCode)
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
}
