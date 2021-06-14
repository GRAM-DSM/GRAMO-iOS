//
//  SignUpVC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/10.
//

import UIKit
import DropDown

class SignUpVC: UIViewController {
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var checkTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var pwConformTxtField: UITextField!
    
    @IBOutlet weak var authenticationBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var failLabel: UILabel!
    
    private let dropDown = DropDown()
    private let httpClient = HTTPClient()
    
    var trueEmail: Bool = false
    var trueMajor: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        customTxtField(nameTxtField)
        customTxtField(pwTxtField)
        customTxtField(pwConformTxtField)
        customTxtField(emailTxtField)
        customTxtField(checkTxtField)
        
        customBtn(authenticationBtn)
        customBtn(checkBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func didTapDropDownBtn(_ sender: UIButton) {
        var selection = String()
        
        customDropDown()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            
            selection = item
            
            majorLabel.text = "\(selection)"
            majorLabel.textColor = UIColor.black
            
            dropDown.clearSelection()
            
            trueMajor = true
        }
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        postSignUp(name: nameTxtField.text!, email: emailTxtField.text!, password: pwTxtField.text!, major: selectMajor(majorLabel))
    }
    
    @IBAction func getSendEmailBtn(_ sender: UIButton) {
        postSendEmail(email: self.emailTxtField.text!)
    }
    
    @IBAction func checkEmailBtn(_ sender: UIButton) {
        postCheckEmailAuthenticationCode(email: self.emailTxtField.text!, code: Int(self.checkTxtField.text!)!)
    }
    
    @IBAction func didTapExitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated : true)
    }
    
    func postSignUp(name : String, email : String, password : String, major : String) {
        guard let conformPwd = pwConformTxtField.text else { return }
        
        if trueMajor == true {
            if trueEmail == true {
                httpClient.post(url: AuthAPI.signUp.path(), params: ["email": email, "password": password, "name": name, "major": major], header: Header.tokenIsEmpty.header())
                    .responseJSON(completionHandler: {(response) in
                    switch response.response?.statusCode {
                    case 200:
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated : true)
                            
                    case 409:
                        print("This email is already in use. - postSignIn")
                        
                        if password != conformPwd {
                            UIView.animate(withDuration: 0.2, animations: {
                                self.pwTxtField.frame.origin.x -= 10
                                self.pwConformTxtField.frame.origin.x -= 10
                            
                                }, completion: { _ in
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.pwTxtField.frame.origin.x += 20
                                    self.pwConformTxtField.frame.origin.x += 20
                                
                                    }, completion: { _ in
                                    UIView.animate(withDuration: 0.2, animations: {
                                        self.pwTxtField.frame.origin.x -= 10
                                        self.pwConformTxtField.frame.origin.x -= 10
                                    })
                                })
                            })
                        
                            self.failLabel.text = "비밀번호가 일치하지 않습니다"
                        }
                        
                    default:
                        print(response.response?.statusCode)
                        print(response.error)
                    }
                })
            } else {
                failLabel.text = "인증번호가 일치하지 않습니다"
            }
        } else {
            failLabel.text = "분야를 선택해주세요"
        }
    }
    
    func postSendEmail(email: String) {
        httpClient.post(url: AuthAPI.sendEmail.path(), params: ["email": email], header: Header.tokenIsEmpty.header())
            .responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                self.failLabel.text = ""
                
            case 409:
                print("This email is already in use. - postSendEmail")
                
                self.failLabel.text = "중복된 이메일 입니다"
                
            default:
                print(response.response?.statusCode)
                print(response.error)
            }
        })
    }
    
    func postCheckEmailAuthenticationCode(email: String, code: Int) {
        httpClient.post(url: AuthAPI.checkEmailCode.path(), params: ["email": email, "code": code], header: Header.tokenIsEmpty.header())
            .responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                self.failLabel.text = ""
                self.trueEmail = true
                
            case 404:
                print("This email does not exist. - postCheckEmailAuthenticationCode")
                self.failLabel.text = "올바른 이메일이 아닙니다"
                
                
            case 409:
                print("Email and code does not match. - postCheckEmailAuthenticationCode")
                self.failLabel.text = "인증번호가 일치하지 않습니다"
                
            default:
                print(response.response?.statusCode)
                print(response.error)
            }
        })
    }
    
    func customTxtField(_ txtField: UITextField) {
        txtField.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    func customDropDown() {
        dropDown.dataSource = ["iOS 개발자", "안드로이드 개발자", "서버 개발자", "디자이너"]
        
        dropDown.width = 342
        dropDown.cellHeight = 40
        dropDown.anchorView = dropDownBtn
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.textFont = UIFont.systemFont(ofSize: 14)
        dropDown.selectionBackgroundColor = UIColor.white
        
        dropDown.show()
    }
    
    func customBtn(_ btn: UIButton) {
        btn.layer.cornerRadius = 8
    }
    
    func selectMajor(_ label: UILabel) -> String {
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
}
