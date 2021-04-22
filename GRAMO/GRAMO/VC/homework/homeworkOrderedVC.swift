//
//  homeworkAllocatorVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

class homeworkOrderedVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var majorButton: UIButton!
    @IBOutlet weak var selectDeadLineTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var httpClient = HTTPClient()
    var model: [HwContent] = [HwContent]()
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        deleteHw(id)
    }
    
    @IBAction func returnButton(_ sender: UIButton){
        rejectedHw(id)
    }
    
    @IBAction func doneButton(_ sender: UIButton){
        submitHw(id)
    }
    
    func getContent(_ id: Int) {
        print("GetContent 호출됨")
        httpClient.get(NetworkingAPI.getHwContent(id)).responseJSON {(res) in
            print(res.data)
            switch res.response?.statusCode {
            case 200 :
                do{
                    print("OK")
                    let data = res.data
                    let model = try JSONDecoder().decode(HwContent.self, from: data!)
                    self.selectDeadLineTxt.text = model.endDate
                    self.dateLabel.text = model.startDate
                    self.nameLabel.text = model.studentName
                    self.majorButton.setTitle(model.major, for: .normal)
                    self.titleTxt.text = model.title
                    self.contentTxt.text = model.description
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
        httpClient.patch(NetworkingAPI.submitHw(id)).responseJSON {(res) in
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
    
    func deleteHw(_ id : Int) {
        print("delete 호출됨")
        httpClient.delete(NetworkingAPI.deleteHw(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 200 :
                print("OK")
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            default : print(res.response?.statusCode)
            }
        }
    }
    
    func rejectedHw(_ id: Int){
        print("rejected 호출됨")
        httpClient.patch(NetworkingAPI.rejectHw(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 201 :
                print("OK")
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
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
