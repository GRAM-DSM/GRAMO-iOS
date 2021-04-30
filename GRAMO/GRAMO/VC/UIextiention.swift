//
//  UIextiention.swift
//  GRAMO
//
//  Created by 장서영 on 2021/04/28.
//

import UIKit

extension UIViewController {
    
    func formatStartDate(_ startDate: String)-> String {
        let finalDate = startDate.components(separatedBy: ["-", ":"," "])
        let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
        
        return formattedDate
    }
    
    func formatEndDate(_ endDate: String) -> String {
        let finalDate = endDate.components(separatedBy: ["-", ":"," "])
        let formattedDate = finalDate[1] + "월 " + finalDate[2] + "일까지"
        
        return formattedDate
    }
    
    func setMajor(_ major: String) -> String {
        switch major {
        case "ANDROID":
            return "안드로이드"
        case "IOS":
            return "iOS"
        case "BACKEND":
            return "서버"
        case "DESIGN":
            return "디자인"
        default:
            print("setMajor error")
        }
        return "error"
    }
    
    
    func setNavigationBar(){
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    
}
