//
//  homeworkAddVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit
import DropDown
import Alamofire

class homeworkAddVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectMajorButton: UIButton!
    @IBOutlet weak var deadLineButton: UIButton!
    @IBOutlet weak var allocatorButton: UIButton!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var detailTxtView: UITextView!
    
    let httpclient = HTTPClient()
    var majorItem = String()
    var allocatorItem = String()
    
    private var userModel : [UserList] = [UserList]()
    private var userListModel : User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dateLabel.adjustsFontSizeToFitWidth == false {
            dateLabel.adjustsFontSizeToFitWidth = true
        }
        
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = date.string(from: Date())
        dateLabel.text = currentDate
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func selectMajor(_ sender: UIButton){
        
        
        
        let dropdown = DropDown()
        dropdown.dataSource = ["iOS", "안드로이드", "서버", "디자인"]
        dropdown.show()
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            selectMajorButton.setTitle("\(item)", for: .normal)
            majorItem = item
        }
        //dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
    }
    
    @IBAction func selectAllocator(_ sender: UIButton){
        httpclient.get(NetworkingAPI.getUserList).responseJSON {(res) in
            print(res.data)
            switch res.response?.statusCode{
            case 200 :
                do {
                    print("Major OK")
                    let data = res.data
                    let model = try JSONDecoder().decode(User.self, from: data!)
                    print(model.userInfoResponses)
                    self.userListModel.userInfoResponses.removeAll()
                    self.userListModel.userInfoResponses.append(contentsOf: model.userInfoResponses)
                    
                    var studentItems = [String]()
                    
                    for i in 0..<model.userInfoResponses.count{
                        studentItems.append(model.userInfoResponses[i].name + "(" + model.userInfoResponses[i].major + ")")
                    }
                    
                    let dropDown = DropDown()
                    dropDown.dataSource = studentItems
                    dropDown.show()
                    dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
                        allocatorButton.setTitle("\(item)", for: .normal)
                        allocatorItem = item
                    }
                    
                }
                catch {
                    print("error")
                    print(error)
                }
            case 401 : print("401 - Unauthorized")
            default : print(res.response?.statusCode)
            }
        }
        
        
    }
    func placeholderSetting() {
        detailTxtView.delegate = self
        detailTxtView.text = "내용을 입력하세요"
        detailTxtView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func addHw() {
        print("addHw")
        httpclient.post(NetworkingAPI.createHw(majorItem, deadLinetTxt.text!, allocatorItem, detailTxtView.text!, titleTxt.text!)).responseJSON{(res) in
            switch res.response?.statusCode{
            case 201 : print("OK - CREATED")
            case 400 : print("400 - BAD REQUEST")
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
