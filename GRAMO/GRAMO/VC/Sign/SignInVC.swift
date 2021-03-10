//
//  SignInVC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
//

import UIKit

struct LoginModel: Codable{
    let token : String
}

class SignInVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var failLabel: UILabel!
    
    private var model : LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.emailTxtField.becomeFirstResponder()
        
    }

    // 로그인 버튼을 눌렀을 때의 동작
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        // 옵셔널 바인딩 & 예외 처리: Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let username = emailTxtField.text, !username.isEmpty else { return }
        guard let password = pwTxtField.text, !password.isEmpty else { return }

        postLogin(email: emailTxtField.text!, password: pwTxtField.text!)
        
    }

    func postLogin(email : String, password : String){
        let httpClient = HTTPClient()
        
        httpClient.post(.Login(email, password)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode{
            case 200 :
                print("로그인 성공")
                
                guard let data = response.data else {return}
                guard let model = try? JSONDecoder().decode(LoginModel.self, from: data) else { return }
                
                self.model = model
                
            default :
                print("로그인 실패")
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.emailTxtField.frame.origin.x -= 10
                    self.pwTxtField.frame.origin.x -= 10

                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.emailTxtField.frame.origin.x += 20
                        self.pwTxtField.frame.origin.x += 20

                    }, completion: { _ in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.emailTxtField.frame.origin.x -= 10
                            self.pwTxtField.frame.origin.x -= 10

                        })

                    })

                })

                self.failLabel.textColor = UIColor.red
                    
            }
            
        })
        
    }
    
    @objc func didEndOnExit(_ sender: UITextField) {
        if emailTxtField.isFirstResponder {
            pwTxtField.resignFirstResponder()
            
        }
    
    }
    
}

