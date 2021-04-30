//
//  SideMenuVCViewController.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/05.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func info(_ sender : UIButton) {
        let vc = (storyboard?.instantiateViewController(identifier: "homework")) as! HomeworkListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homework(_ sender: UIButton) {
        let vc = HomeworkListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logOut(_ sender: UIButton){
        
    }
    
    @IBAction func withdrawal(_ sender: UIButton){
        
    }
    
    func getProfile(){
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
