//
//  SideMenuVCViewController.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/05.
//

import UIKit

final class SideMenuViewController: UIViewController {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var majorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        nameLabel?.text = UserDefaults.standard.string(forKey: "nickname")
        majorLabel?.text = UserDefaults.standard.string(forKey: "major")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameLabel?.text = UserDefaults.standard.string(forKey: "nickname")
        majorLabel?.text = UserDefaults.standard.string(forKey: "major")
    }
    
    @IBAction private func calendar(_ sender: UIButton) {
        let sub = UIStoryboard(name: "Calendar2", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "Calendar2VC")
        self.navigationController?.pushViewController(calendar, animated: false)
    }
    
    @IBAction private func info(_ sender : UIButton) {
        let sub = UIStoryboard(name: "info", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "infoListViewController")
        self.navigationController?.pushViewController(calendar, animated: false)
    }
    
    @IBAction private func homework(_ sender: UIButton) {
        let sub = UIStoryboard(name: "homework", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "homeworkVC")
        self.navigationController?.pushViewController(calendar, animated: false)
    }
    
    @IBAction private func logOut(_ sender: UIButton){
        showDeleteAlert(title: "로그아웃 하시겠습니까?", action: { [unowned self](action) in logout() }, message: nil)
    }
    
    @IBAction private func withdrawal(_ sender: UIButton){
        HTTPClient().delete(url: AuthAPI.withDrawel.path(), params: nil, header: Header.accessToken.header()).responseJSON(completionHandler: { [unowned self]res in
            switch res.response?.statusCode {
            case 204 :
                let sub = UIStoryboard(name: "Auth", bundle: nil)
                let calendar = sub.instantiateViewController(withIdentifier: "LoginVC")
                navigationController?.pushViewController(calendar, animated: false)
                
            case 401: print("401 - could not find token user")
                showAlert(title: "허가되지 않은 요청입니다.",message: nil)
                
            default:
                print(res.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        })
    }
    
    private func logout() {
        HTTPClient().delete(url: AuthAPI.logout.path(), params: nil, header: Header.accessToken.header()).responseJSON(completionHandler: { [unowned self]res in
            switch res.response?.statusCode {
            case 200 :
                let sub = UIStoryboard(name: "Auth", bundle: nil)
                let calendar = sub.instantiateViewController(withIdentifier: "SignInVC")
                navigationController?.pushViewController(calendar, animated: false)
                UserDefaults.standard.setValue("", forKey: "refreshToken")
                
            case 401: print("401 - could not find token user")
                showAlert(title: "허가되지 않은 요청입니다.", message: nil)
            default:
                print(res.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        })
    }
}
