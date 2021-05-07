//
//  SignUpVC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            self.dropDown.clearSelection()
        }
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        postSignUp(name: nameTxtField.text!, email: emailTxtField.text!, password: pwTxtField.text!, major: majorLabel.text!)
    }
    
    @IBAction func getSendEmailBtn(_ sender: UIButton) {
        getSendEmail(email: self.emailTxtField.text!)
    }
    
    @IBAction func checkEmailBtn(_ sender: UIButton) {
        putCheckEmailAuthenticationCode(code: self.checkTxtField.text!)
    }
    
    @IBAction func didTapExitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated : true)
    }
    
    func postSignUp(name : String, email : String, password : String, major : String) {
        guard let conformPwd = pwConformTxtField.text else { return }
        
        if trueEmail == true {
            httpClient.post(.signUp(name, email, password, major)).responseJSON(completionHandler: {(response) in
                switch response.response?.statusCode {
                case 201:
                    print("회원가입 성공")
                    
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated : true)
                        
                case 404:
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
                    
                        self.failLabel.text = "비밀번호가 일치하지 않습니다"
                    }
                    
                default:
                    print(response.response?.statusCode)
                    print(response.error)
                }
            })
        }
        
        failLabel.text = "인증번호가 일치하지 않습니다"
    }
    
    func getSendEmail(email : String) {
        httpClient.get(.sendEmail(email)).responseJSON(completionHandler: {
            reponse in
            switch reponse.response?.statusCode {
            case 200:
                print("이메일 성공")
                
            default:
                print("이메일 실패")
                
                self.failLabel.text = "중복된 이메일 입니다"
            }
        })
    }
    
    func putCheckEmailAuthenticationCode(code : String) {
        httpClient.put(.checkEmailCode(code)).responseJSON(completionHandler: {
            reponse in
            switch reponse.response?.statusCode {
            case 200:
                print("이메일 인증 성공")
                self.trueEmail = true
                
            default:
                print("이메일 인증 실패")
            }
        })
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
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
}
