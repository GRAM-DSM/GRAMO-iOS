//
//  homeworkAssignedVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

class HomeworkAssignedVC: UIViewController {
    
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
        getContent(id)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton1(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton2(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitButton(_ sender: UIButton){
        submitHw(id)
    }
    
    func setNavigationBar(){
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func getContent(_ id: Int) {
        print("GetContent 호출됨")
        httpClient.get(NetworkingAPI.getHomeworkContent(id)).responseJSON {(res) in
            print(id)
            print(res.data)
            switch res.response?.statusCode {
            case 200 :
                do{
                    print("OK")
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
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            default : print(res.response?.statusCode)
                
            }
        }
        
    }
    
    func submitHw(_ id : Int) {
        print("submit 호출됨")
        httpClient.patch(NetworkingAPI.submitHomework(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 201 :
                print("Created")
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            default : print(res.response?.statusCode)
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
