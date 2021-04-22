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
    @IBOutlet weak var deadLinetTxt: UITextField!
    @IBOutlet weak var allocatorButton: UIButton!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var detailTxtView: UITextView!
    
    let datePicker = UIDatePicker()
    
    let httpclient = HTTPClient()
    var majorItem = String()
    var allocatorItem = String()
    var requestDate = String()
    var studentEmail = String()
    var requestMajor = String()
    
    private var userModel : [UserList] = [UserList]()
    private var userListModel : User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
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
        addHw()
    }
    
    @IBAction func selectMajor(_ sender: UIButton){
        let dropdown = DropDown()
        dropdown.dataSource = ["iOS", "안드로이드", "서버", "디자인"]
        dropdown.show()
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            selectMajorButton.setTitle("\(item)", for: .normal)
            majorItem = item
            
            switch majorItem {
            case "iOS": requestMajor = "IOS"
            case "안드로이드": requestMajor = "ANDROID"
            case "서버" : requestMajor = "BACKEND"
            case "디자인" : requestMajor = "DESIGN"
            default:
                print("TTI YONG")
            }
        }
        //dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
    }
    
    @IBAction func selectAllocator(_ sender: UIButton){
        httpclient.get(NetworkingAPI.getUserList).responseJSON { [self](res) in
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
                        self.studentEmail = model.userInfoResponses[index].email
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
    
    func createDatePicker() {
        
        deadLinetTxt.textAlignment = .center
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        
        deadLinetTxt.inputAccessoryView = toolBar
        
        deadLinetTxt.inputView = datePicker
        
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.datePickerMode = .date
        
        datePicker.locale = Locale(identifier: "ko-KR")
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        formatter.dateFormat = "yyyy년 MM월 dd일"
        deadLinetTxt.text = formatter.string(from: datePicker.date)
        
        let requestFormatter = DateFormatter()
        requestFormatter.dateFormat = "yyyy-MM-dd"
        
        requestDate = requestFormatter.string(from: datePicker.date)
        
        print(requestDate)
        
        self.view.endEditing(true)
    }
    
    func addHw() {
        print("addHw")
        print(studentEmail)
        httpclient.post(NetworkingAPI.createHw(requestMajor, requestDate, studentEmail, detailTxtView.text!, titleTxt.text!)).responseJSON{(res) in
            switch res.response?.statusCode{
            case 201 :
                do{
                    print("OK - CREATED")
                    self.navigationController?.popViewController(animated: true)
                }
                catch {
                    print("error: \(error)")
                }
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
