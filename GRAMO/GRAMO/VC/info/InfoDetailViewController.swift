//
//  infoDetailVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/22.
//

import UIKit

let detailVC : Notification.Name = Notification.Name("detailVC")

final class InfoDetailViewController: UIViewController {
    
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var titleTxt: UITextView!
    @IBOutlet weak private var detailTxt: UITextView!
    @IBOutlet weak private var deleteBtn: UIButton!
    
    let httpclient = HTTPClient()
    var model: [noticeDetail] = [noticeDetail]()
    var detailModel = GetNoticeDetail.self
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailNotice(id: id)
        
//        nameLabel.text = "장서영"
//        dateLabel.text = "2021년 11월 17일"
//        titleTxt.text = "성과전시회"
//        detailTxt.text = "성과전시회에 GRAMO 낼게요"
        
        self.isModalInPresentation = false
    }
    
    @IBAction private func deleteNotice(_ sender: UIButton) {
        showDeleteAlert(title: "삭제하시겠습니까?", action: { [unowned self](action) in deleteNotice(id: id)}, message: "되돌리기는 불가능합니다.")
        
    }
    
    private func detailNotice(id: Int){
        httpclient.get(url: NoticeAPI.getNoticeDetail(id).path(), params: ["id":id], header: Header.accessToken.header()).responseJSON {[unowned self](res) in
            switch res.response?.statusCode{
            case 200:
                
                let model = try? JSONDecoder().decode(GetNoticeDetail.self, from: res.data!)
                nameLabel.text = model!.notice.name
                dateLabel.text = formatStartDate(model!.notice.created_at)
                titleTxt.text = model!.notice.title
                detailTxt.text = model!.notice.content
                
            case 401:
                print("401 - getNoticeDetail")
                tokenRefresh()
                
            case 404: print("404 - Not Found")
                showAlert(title: "오류가 발생했습니다.", message: nil)
                
            default: print(res.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    private func deleteNotice(id: Int){
        httpclient.delete(url: NoticeAPI.deleteNotice(id).path(), params: nil, header: Header.accessToken.header()).responseJSON{[unowned self](res) in
            switch res.response?.statusCode{
            case 200:
                dismiss(animated: true)
                NotificationCenter.default.post(name: detailVC, object: nil, userInfo: nil)
                
            case 401:
                print("401 - deleteNotice")
                tokenRefresh()
                
            case 403:
                print("403 - Forbidden")
                showAlert(title: "권한이 없습니다.", message: "타인의 게시물을 삭제할 수 없습니다.")
                
            case 404: print("404 - Not Found")
                showAlert(title: "오류가 발생했습니다.", message: nil)
                
            default: print(res.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
}
