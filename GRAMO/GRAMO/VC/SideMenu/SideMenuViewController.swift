//
//  SideMenuVCViewController.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/05.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        nameLabel.text = UserDefaults.standard.object(forKey: "nickname") as! String
        majorLabel.text = UserDefaults.standard.object(forKey: "major") as! String
        // Do any additional setup after loading the view.
    }
    
    @IBAction func calendar(_ sender: UIButton) {
        let sub = UIStoryboard(name: "Calendar2", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "Calendar2VC")
        self.navigationController?.pushViewController(calendar, animated: false)
    }
    
    @IBAction func info(_ sender : UIButton) {
        let sub = UIStoryboard(name: "info", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "infoListViewController")
        self.navigationController?.pushViewController(calendar, animated: false)
    }
    
    @IBAction func homework(_ sender: UIButton) {
        let sub = UIStoryboard(name: "homework", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "homeworkVC")
        self.navigationController?.pushViewController(calendar, animated: false)
    }
    
    @IBAction func logOut(_ sender: UIButton){
        let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "예", style: .destructive){ [self](action) in
            logout() }
        
        alert.addAction(cancelAction)
        alert.delete(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func withdrawal(_ sender: UIButton){
        HTTPClient().delete(url: AuthAPI.withDrawel.path(), params: nil, header: Header.token.header()).responseJSON(completionHandler: { res in
            switch res.response?.statusCode {
            case 204 : print("OK")
                let sub = UIStoryboard(name: "Auth", bundle: nil)
                let calendar = sub.instantiateViewController(withIdentifier: "LoginVC")
                self.navigationController?.pushViewController(calendar, animated: false)
            case 401: print("401 - could not find token user")
            default:
                print(res.response?.statusCode)
            }
        })
    }
    
    func logout() {
        HTTPClient().delete(url: AuthAPI.logout.path(), params: nil, header: Header.token.header()).responseJSON(completionHandler: { res in
            switch res.response?.statusCode {
            case 204 : print("OK")
                let sub = UIStoryboard(name: "Auth", bundle: nil)
                let calendar = sub.instantiateViewController(withIdentifier: "LoginVC")
                self.navigationController?.pushViewController(calendar, animated: false)
            case 401: print("401 - could not find token user")
            default:
                print(res.response?.statusCode)
            }
        })
    }
}
