//
//  SignUpVC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
//

import UIKit
import DropDown

class SignUpVC: UIViewController {
    // 프로퍼티
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var pwConformTxtField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var authenticationBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var checkTxtField: UITextField!
    
    @IBOutlet weak var dropDownBtn: UIButton!
    
    @IBOutlet weak var failEmailLabel: UILabel! // 중복된 이메일
    @IBOutlet weak var failCheckLabel: UILabel! // 인증번호
    @IBOutlet weak var failPasswordLabel: UILabel! // 비밀번호 일치
    
    let dropDown = DropDown()
    var selection: String = ""
    let httpClient = HTTPClient()
    var emailTrue: Bool = false
    
    @IBAction func dropDownBtn(_ sender: UIButton) {
        dropDown.dataSource = ["iOS 개발자", "안드로이드 개발자", "서버 개발자", "디자이너"]
        
        dropDown.width = 342 // 넓이
        dropDown.anchorView = dropDownBtn // 버튼에
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!) // 버튼 아래
        // dropDown.
        dropDown.textFont = UIFont.systemFont(ofSize: 14) // 폰트 사이즈
        dropDown.selectionBackgroundColor = UIColor.white // 배경색
        dropDown.cellHeight = 40 // 높이
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            
            selection = item
            
            majorTextField.text = "    \(selection)"
            majorTextField.textColor = UIColor.black
            
            self.dropDown.clearSelection()
            
        }
        
    }
    
    // 회원가입 버튼을 눌렀을 때 액션
    @IBAction func signUpBtn(_ sender: UIButton) {
        if emailTrue == true {
            self.postSignUp(name: self.nameTxtField.text!, email: self.emailTxtField.text!, password: self.pwTxtField.text!, major: self.majorTextField.text!)
            
        } else {
            return
            
        }
        
    }
    
    @IBAction func getSendEmailBtn(_ sender: UIButton) {
        self.getSendEmail(email: self.emailTxtField.text!)
        
    }
    
    @IBAction func checkBtn(_ sender: UIButton) {
        self.putCheckEmailAuthenticationCode(code: self.checkTxtField.text!)
        
    }
    
    func postSignUp(name : String, email : String, password : String, major : String){
        guard let conformPwd = pwConformTxtField.text else { return }
        
        httpClient.post(.SignUp(name, email, password, major)).responseJSON(completionHandler: {
            reponse in
            switch reponse.response?.statusCode {
            case 201:
                print("회원가입 성공")
                
                self.navigationController?.popViewController(animated: true)
                    
            default:
                print("회원가입 실패")
                
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
                
                    self.failPasswordLabel.textColor = UIColor.red
                    
                }
            }
            
        })
        
    }
    
    func getSendEmail(email : String) {
        httpClient.get(.SendEmail(email)).responseJSON(completionHandler: {
            reponse in
            switch reponse.response?.statusCode {
            case 200:
                print("이메일 성공")
                
            default:
                print("이메일 실패")
                
                self.failEmailLabel.textColor = UIColor.red
                
            }
            
        })
        
    }
    
    func putCheckEmailAuthenticationCode(code : String) {
        httpClient.put(.CheckEmailAuthenticationCode(code)).responseJSON(completionHandler: {
            reponse in
            switch reponse.response?.statusCode {
            case 200:
                print("이메일 인증 성공")
                self.emailTrue = true
                
            default:
                print("이메일 인증 실패")
                
            }
            
        })
        
    }

    // viewDidLoad
    // Return Key addTarget
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTxtField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        pwTxtField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        pwConformTxtField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        
        authenticationBtn.layer.cornerRadius = 8
        checkBtn.layer.cornerRadius = 8
        
    }
        
        
    // 나가는 함수
    @IBAction func didTapExitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil) // 화면 내리기
        
        self.navigationController?.popViewController(animated : true)
        
    }
        
    // 키보드 내리기 함수
    @objc func didEndOnExit(_ sender: UITextField) {
        if nameTxtField.isFirstResponder {
            pwTxtField.becomeFirstResponder()
            
        } else if pwTxtField.isFirstResponder {
            pwConformTxtField.becomeFirstResponder()
            
        }
        
    }
    
}

