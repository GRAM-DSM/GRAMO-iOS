//
//  SignInVC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
//

import UIKit

// MARK: SignInVC
class SignInVC: UIViewController {
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var failLabel: UILabel!
    
    private var signInModel: SignIn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTxtField(emailTxtField)
        customTxtField(pwTxtField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func didTapLoginBtn(_ sender: UIButton) {
        guard let email = emailTxtField.text, !email.isEmpty else { return }
        guard let password = pwTxtField.text, !password.isEmpty else { return }

        signIn(email: email, password: password)
    }
    
    func signIn(email : String, password : String){
        let httpClient = HTTPClient()
        
        httpClient.post(.signIn(email, password)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 201:
                do {
                    print("OK - Send notice list successfully. - signIn")
                    
                    let data = response.data
                    let model = try JSONDecoder().decode(SignIn.self, from: data!)
                    
                    self.signInModel = model
                    
                    print(self.signInModel)
                } catch {
                    print("Error: \(error)")
                }
                
            case 400:
                print("400 : BAD REQUEST - signIn")
                
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
                            
            case 404:
                print("404 : NOT FOUND - Notice does not exist. - signIn")
                
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
                
            default:
                print(response.response?.statusCode)
                print(response.error)
            }
        })
    }
    
    func customTxtField(_ txtField: UITextField) {
        txtField.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
}