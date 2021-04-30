//
//  SideMenuVCViewController.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/05.
//

import UIKit

class SideMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func setNavigationBar(){
        let bar:UINavigationBar! =  navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    @IBAction func info(_ sender : UIButton) {
        let vc = (storyboard?.instantiateViewController(identifier: "homework")) as! HomeworkListVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homework(_ sender: UIButton) {
        let vc = HomeworkListVC()
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
