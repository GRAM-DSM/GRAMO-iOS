//
//  SideMenuNavigationController.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/05.
//

import UIKit
import SideMenu

class SideMenuNav: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentationStyle = .menuSlideIn
        self.leftSide = true
        self.menuWidth = self.view.frame.width * 0.45
        // Do any additional setup after loading the view.
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
