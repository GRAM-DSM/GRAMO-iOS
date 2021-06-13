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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func calendar(_ sender: UIButton) {
        let sub = UIStoryboard(name: "Calendar2", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "Calendar2VC")
        self.navigationController?.pushViewController(calendar, animated: true)
    }
    
    @IBAction func info(_ sender : UIButton) {
        let sub = UIStoryboard(name: "info", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "infoListViewController")
        self.navigationController?.pushViewController(calendar, animated: true)
    }
    
    @IBAction func homework(_ sender: UIButton) {
        let sub = UIStoryboard(name: "homework", bundle: nil)
        let calendar = sub.instantiateViewController(withIdentifier: "homeworkVC")
        self.navigationController?.pushViewController(calendar, animated: true)
    }
    
    @IBAction func logOut(_ sender: UIButton){
        
    }
    
    @IBAction func withdrawal(_ sender: UIButton){
        
    }
    
    func getProfile(){
        
    }
}
