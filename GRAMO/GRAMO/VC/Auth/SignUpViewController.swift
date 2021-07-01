//
//  SignUpVC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/10.
//

import UIKit
import DropDown

final class SignUpViewController: UIViewController {
    @IBOutlet weak private var nameTxtField: UITextField!
    @IBOutlet weak private var emailTxtField: UITextField!
    @IBOutlet weak private var checkTxtField: UITextField!
    @IBOutlet weak private var pwTxtField: UITextField!
    @IBOutlet weak private var pwConformTxtField: UITextField!
    
    @IBOutlet weak private var authenticationButton: UIButton!
    @IBOutlet weak private var checkButton: UIButton!
    @IBOutlet weak private var dropDownButton: UIButton!
    
    @IBOutlet weak private var majorLabel: UILabel!
    @IBOutlet weak private var failLabel: UILabel!
    
    @IBOutlet weak private var majorView: UIView!
    
    private let dropDown = DropDown()
    private let httpClient = HTTPClient()
    
    private var trueEmail: Bool = false
    private var trueMajor: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        customTxtField(nameTxtField)
        customTxtField(pwTxtField)
        customTxtField(pwConformTxtField)
        customTxtField(emailTxtField)
        customTxtField(checkTxtField)
        
        customBtn(authenticationButton)
        customBtn(checkButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction private func didTapDropDownBtn(_ sender: UIButton) {
        var selection = String()
        
        customDropDown()
        
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            
            selection = item
            
            majorLabel.text = "\(selection)"
            majorLabel.textColor = UIColor.black
            
            dropDown.clearSelection()
            
            trueMajor = true
        }
    }
    
    @IBAction private func signUpBtn(_ sender: UIButton) {
        if trueMajor == true {
            if trueEmail == true {
                postSignUp(name: nameTxtField.text!, email: emailTxtField.text!, password: pwTxtField.text!, major: selectMajor(majorLabel))
            } else {
                failLabel.text = "인증번호가 일치하지 않습니다"
            }
        } else {
            failLabel.text = "분야를 선택해주세요"
        }
    }
    
    @IBAction private func getSendEmailBtn(_ sender: UIButton) {
        postSendEmail(email: self.emailTxtField.text!)
    }
    
    @IBAction private func checkEmailBtn(_ sender: UIButton) {
        postCheckEmailAuthenticationCode(email: self.emailTxtField.text!, code: Int(self.checkTxtField.text!)!)
    }
    
    @IBAction private func didTapExitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated : true)
    }
    
    private func customTxtField(_ txtField: UITextField) {
        txtField.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    private func customDropDown() {
        dropDown.dataSource = ["iOS 개발자", "안드로이드 개발자", "서버 개발자", "디자이너"]
        
        dropDown.width = majorView.fs_width
        dropDown.cellHeight = 40
        dropDown.anchorView = majorView
        dropDown.textFont = UIFont.systemFont(ofSize: 14)
        dropDown.selectedTextColor = UIColor.red
        dropDown.backgroundColor = UIColor.white
        
        dropDown.show()
    }
    
    private func customBtn(_ btn: UIButton) {
        btn.layer.cornerRadius = 8
    }
    
    private func selectMajor(_ label: UILabel) -> String {
        switch label.text! {
        case "iOS 개발자":
            return "IOS"
            
        case "안드로이드 개발자":
            return "ANDROID"
            
        case "서버 개발자":
            return "BACKEND"
            
        case "디자이너":
            return "DESIGN"
            
        default:
            return ""
        }
    }
    
    private func postSignUp(name : String, email : String, password : String, major : String) {
        guard let conformPwd = pwConformTxtField.text else { return }
        
        httpClient
            .post(url: AuthAPI.signUp.path(), params: ["email": email, "password": password, "name": name, "major": major], header: Header.tokenIsEmpty.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 200:
                    print("OK - postSignUp")
                    
                    dismiss(animated: true, completion: nil)
                    navigationController?.popViewController(animated : true)
                    
                case 409:
                    print("This email is already in use. - postSignIn")
                    
                    if password != conformPwd {
                        animationTxtField(firstTxtField: pwTxtField, secondTxtField: pwConformTxtField)
                        failLabel.text = "비밀번호가 일치하지 않습니다"
                    }
                    
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
    
    private func postSendEmail(email: String) {
        httpClient
            .post(url: AuthAPI.sendEmail.path(), params: ["email": email], header: Header.tokenIsEmpty.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 200:
                    print("OK - postSendEmail")
                    failLabel.text = ""
                    
                case 409:
                    print("This email is already in use. - postSendEmail")
                    
                    failLabel.text = "중복된 이메일 입니다"
                    
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
    
    private func postCheckEmailAuthenticationCode(email: String, code: Int) {
        httpClient
            .post(url: AuthAPI.checkEmailCode.path(), params: ["email": email, "code": code], header: Header.tokenIsEmpty.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 200:
                    print("OK - postCheckEmailAuthenticationCode")
                    
                    failLabel.text = ""
                    trueEmail = true
                    
                case 404:
                    print("This email does not exist. - postCheckEmailAuthenticationCode")
                    failLabel.text = "올바른 이메일이 아닙니다"
                    
                case 409:
                    print("Email and code does not match. - postCheckEmailAuthenticationCode")
                    failLabel.text = "인증번호가 일치하지 않습니다"
                
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
}
