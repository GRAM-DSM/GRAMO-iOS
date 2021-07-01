//
//  SignInVC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/10.
//

import UIKit

final class SignInViewController: UIViewController {
    @IBOutlet weak private var emailTxtField: UITextField!
    @IBOutlet weak private var pwTxtField: UITextField!
    @IBOutlet weak private var failLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        customTxtField(emailTxtField)
        customTxtField(pwTxtField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction private func didTapLoginBtn(_ sender: UIButton) {
        guard let email = emailTxtField.text, !email.isEmpty else { return }
        guard let password = pwTxtField.text, !password.isEmpty else { return }
        
        signIn(email: email, password: password)
    }
    
    private func customTxtField(_ txtField: UITextField) {
        txtField.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    private func signIn(email : String, password : String) {
        let httpClient = HTTPClient()
        
        httpClient
            .post(url: AuthAPI.signIn.path(), params: ["email": email, "password": password], header: Header.tokenIsEmpty.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 201:
                    do {
                        print("OK - signIn")
                        
                        let data = response.data
                        let model = try JSONDecoder().decode(SignIn.self, from: data!)
                        
                        print(model)
                        Token.token = model.access_token
                        
                        UserDefaults.standard.object(forKey: "nickname")
                        UserDefaults.standard.setValue(model.name, forKey: "nickname")
                        
                        UserDefaults.standard.object(forKey: "major")
                        UserDefaults.standard.setValue(model.major, forKey: "major")
                        
                        let sub = UIStoryboard(name: "Calendar2", bundle: nil)
                        let info = sub.instantiateViewController(withIdentifier: "Calendar2VC")
                        
                        navigationController?.pushViewController(info, animated: true)
                    } catch {
                        print("Error: \(error)")
                    }
                    
                case 400:
                    print("400 : BAD REQUEST - signIn")
                    animationTxtField(firstTxtField: emailTxtField, secondTxtField: pwTxtField)
                    
                    failLabel.textColor = UIColor.red
                    
                case 404:
                    print("404 : NOT FOUND - Notice does not exist. - signIn")
                    animationTxtField(firstTxtField: emailTxtField, secondTxtField: pwTxtField)
                    
                    failLabel.textColor = UIColor.red
                    
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
}
