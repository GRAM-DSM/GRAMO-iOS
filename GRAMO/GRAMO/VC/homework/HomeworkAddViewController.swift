//
//  homeworkAddVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit
import DropDown
import Alamofire

final class HomeworkAddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var selectMajorButton: UIButton!
    @IBOutlet weak private var deadLinetTextField: UITextField!
    @IBOutlet weak private var allocatorButton: UIButton!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var detailTextView: UITextView!
    @IBOutlet weak private var nameLabel: UILabel!
    
    let datePicker = UIDatePicker()
    
    let httpclient = HTTPClient()
    var majorItem = String()
    var allocatorItem = String()
    var requestDate = String()
    var studentEmail = String()
    var requestMajor = String()
    
    private var userModel : [UserList] = [UserList]()
    private var userListModel : User = User()
    private var signInModel: SignIn!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        
        createDatePicker()
        
        nameLabel.text = UserDefaults.standard.object(forKey: "nickname") as? String
        
        if dateLabel.adjustsFontSizeToFitWidth == false {
            dateLabel.adjustsFontSizeToFitWidth = true
        }
        
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = date.string(from: Date())
        dateLabel.text = currentDate
        
        placeholderSetting()
        textViewDidBeginEditing(detailTextView)
        textViewDidEndEditing(detailTextView)
        setNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_ :)), name: UITextField.textDidChangeNotification, object: titleTextField)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        if titleTextField.textColor == UIColor.lightGray || detailTextView.textColor == UIColor.lightGray {
            showAlert(title: "제목 또는 내용을 입력해주세요.", message: nil)
        }
        addHomework(major: requestMajor, endDate: requestDate, studentEmail: studentEmail, description: detailTextView.text!, title: titleTextField.text!)
    }
    
    @IBAction func selectMajor(_ sender: UIButton){
        let dropdown = DropDown()
        
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().textColor = UIColor.black
        
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
                print("error")
            }
        }
        dropdown.anchorView = selectMajorButton
    }
    
    @IBAction func selectAllocator(_ sender: UIButton){
        httpclient.get(url: HomeworkAPI.getUserList.path(), params: nil, header: Header.token.header()).responseJSON { [self](res) in
            switch res.response?.statusCode{
            case 200 :
                do {
                    let data = res.data
                    let model = try JSONDecoder().decode(User.self, from: data!)
                    self.userListModel.userInfoResponses.removeAll()
                    self.userListModel.userInfoResponses.append(contentsOf: model.userInfoResponses)
                    
                    var studentItems = [String]()
                    
                    for i in 0..<model.userInfoResponses.count{
                        studentItems.append(model.userInfoResponses[i].name + "(" + model.userInfoResponses[i].major + ")")
                    }
                    
                    let dropDown = DropDown()
                    
                    DropDown.appearance().backgroundColor = UIColor.white
                    DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
                    DropDown.appearance().textColor = UIColor.black
                    
                    dropDown.dataSource = studentItems
                    dropDown.show()
                    dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
                        allocatorButton.setTitle("\(item)", for: .normal)
                        self.studentEmail = model.userInfoResponses[index].email
                    }
                    dropDown.anchorView = allocatorButton
                }
                catch {
                    print(error)
                }
            case 401 : print("401 - Unauthorized")
                self.showAlert(title: "허가되지 않은 요청입니다.",message: nil)
            default : print(res.response?.statusCode ?? "default")
            }
        }
    }
    
    func addHomework(major: String, endDate: String, studentEmail: String, description: String, title: String) {
        httpclient.post(url: HomeworkAPI.createHomework.path(), params: ["major":major, "endDate":endDate, "studentEmail":studentEmail, "description":description, "title":title], header: Header.token.header()).responseJSON{(res) in
            switch res.response?.statusCode{
            case 201 :
                self.navigationController?.popViewController(animated: true)
                
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.", message: nil)
            case 404 : print("404 - NOT FOUND createHw")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(res.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    func placeholderSetting() {
        detailTextView.delegate = self
        detailTextView.text = "내용을 입력하세요"
        detailTextView.textColor = UIColor.lightGray
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
        
        deadLinetTextField.textAlignment = .center
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        
        deadLinetTextField.inputAccessoryView = toolBar
        
        deadLinetTextField.inputView = datePicker
        
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.datePickerMode = .date
        
        datePicker.locale = Locale(identifier: "ko-KR")
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        formatter.dateFormat = "yyyy년 MM월 dd일"
        deadLinetTextField.text = formatter.string(from: datePicker.date)
        
        let requestFormatter = DateFormatter()
        requestFormatter.dateFormat = "yyyy-MM-dd"
        
        requestDate = requestFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 1000
    }
    
    @objc func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                
                if text.count > 50 {
                    textField.resignFirstResponder()
                }
                
                if text.count >= 50 {
                    let index = text.index(text.startIndex, offsetBy: 50)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
            }
        }
    }
}
