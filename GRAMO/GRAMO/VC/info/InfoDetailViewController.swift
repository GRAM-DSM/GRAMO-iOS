//
//  infoDetailVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/22.
//

import UIKit

class InfoDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var detailTxt: UITextView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    let httpclient = HTTPClient()
    var model: [noticeDetail] = [noticeDetail]()
    var detailModel = GetNoticeDetail.self
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailNotice(id)
    }
    
    @IBAction func deleteNotice(_ sender: UIButton) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "되돌리기는 불가능합니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "예", style: .destructive) { [self](action) in self.deleteNotice(id)}
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func detailNotice(_ value: Int){
        httpclient.get(NetworkingAPI.getNoticeDetail(value)).responseJSON {(res) in
            switch res.response?.statusCode{
            case 200:
                do{
                    guard let data = res.data else {return}
                    guard let model = try? JSONDecoder().decode(GetNoticeDetail.self, from: data) else { return}
                    self.nameLabel.text = model.notice.name
                    self.dateLabel.text = self.formatStartDate(model.notice.created_at)
                    self.titleTxt.text = model.notice.title
                    self.detailTxt.text = model.notice.content
                }
                catch{
                    print(error)
                }
            case 404: print("404 - Not Found")
            default: print(res.response?.statusCode)
            }
        }
    }
    
    func deleteNotice(_ value: Int){
        httpclient.delete(NetworkingAPI.deleteNotice(value)).responseJSON{(res) in
            switch res.response?.statusCode{
            case 200:
                self.dismiss(animated: true)
            case 403:
                print("403 - Forbidden")
                let alert = UIAlertController(title: "권한이 없습니다.", message: "타인의 게시물을 삭제할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            case 404: print("404 - Not Found")
            default: print(res.response?.statusCode)
            }
        }
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
