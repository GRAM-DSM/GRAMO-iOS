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
    
    func showAlert(title : String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlert(title: String, action: ((UIAlertAction) -> Void)?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "예", style: .destructive, handler: action)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    public func animationTxtField(firstTxtField: UITextField, secondTxtField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            firstTxtField.frame.origin.x -= 10
            secondTxtField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                firstTxtField.frame.origin.x += 20
                secondTxtField.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    firstTxtField.frame.origin.x -= 10
                    secondTxtField.frame.origin.x -= 10
                })
            })
        })
    }
    
    public func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75,
                                               y: self.view.frame.size.height - 100,
                                               width: 150,
                                               height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
