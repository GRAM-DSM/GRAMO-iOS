//
//  SideMenuNavigationController.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/05.
//

import UIKit
import SideMenu

final class SideMenuNav: SideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationStyle = .menuSlideIn
        self.leftSide = true
        self.menuWidth = self.view.frame.width * 0.45
    }
}
