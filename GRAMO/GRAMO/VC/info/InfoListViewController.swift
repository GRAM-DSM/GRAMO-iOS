//
//  infoListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

var hidden = 0

final class InfoListViewContoller: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let httpClient = HTTPClient()
    private var getListModel: [Notice] = [Notice]()
    private var listModel : GetNoticeList = GetNoticeList()
    
    var page : Int = 0
    var nextPage = Bool()
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.notice.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as! InfoTableViewCell
        
        let date = listModel.notice[indexPath.row].created_at
        let finalDate = date.components(separatedBy: ["-", ":"," "])
        let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
        
//        var formatter_year = DateFormatter()
//        formatter_year.dateFormat = "yyyy년 MM월 dd일"
//        var current_year_string = formatter_year.string(from: Date())
//        print(current_year_string)

        cell.selectionStyle = .none
        
        cell.infoTitleLabel?.text = listModel.notice[indexPath.row].title
        cell.infoDetailLabel?.text = listModel.notice[indexPath.row].content
        cell.dateLabel?.text = formattedDate
        cell.writersName?.text = listModel.notice[indexPath.row].user_name
        
//        cell.infoTitleLabel.text = "성과전시회"
//        cell.infoDetailLabel.text = "성과전시회에 GRAMO 낼게요"
//        cell.dateLabel.text = current_year_string
//        cell.writersName.text = "장서영"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "infoDetailVC") as? InfoDetailViewController else { return }
        
        detailVC.id = listModel.notice[indexPath.row].id
        self.present(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 130
        
        
        
        getList()
        
        setNavigationBar()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostDetailNotification(_:)), name: detailVC, object: nil)
        
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getList()
        
//        if hidden != 0 {
//            tableView.isHidden = false
//        }
    }
    
    private func getList(){
        print("getlist")
        httpClient.get(url: NoticeAPI.getNoticeList(0).path(), params: nil, header: Header.accessToken.header()).responseJSON{[unowned self](response) in
            print(response.response?.statusCode)
            switch response.response?.statusCode{
            case 200:
                let model = try? JSONDecoder().decode(GetNoticeList.self, from: response.data!)
                nextPage = model!.next_page
                listModel.notice.removeAll()
                listModel.notice.append(contentsOf: model!.notice)
                tableView.reloadData()
                
            case 401:
                print("401 - getNoticeList")
                tokenRefresh()
                
            case 404: print("404 : NOT FOUND - Notice does not exist.")
                showAlert(title: "오류가 발생했습니다.", message: nil)
                
            case 418: getList()
                
            default: print(response.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    
    private func secondGetList() {
        getPage()
        if nextPage == true {
            httpClient.get(url: NoticeAPI.getNoticeList(page).path(), params: nil, header: Header.accessToken.header()).responseJSON{[unowned self](response) in
                switch response.response?.statusCode{
                case 200:
                    let model = try? JSONDecoder().decode(GetNoticeList.self, from: response.data!)
                    nextPage = model!.next_page
                    listModel.notice.append(contentsOf: model!.notice)
                    tableView.reloadData()
                    
                case 401:
                    print("401 - getNoticeList")
                    tokenRefresh()
                    
                case 404:
                    showAlert(title: "오류가 발생했습니다.", message: nil)
                    
                default:
                    showAlert(title: "오류가 발생했습니다.", message: nil)
                }
            }
        }
        
    }
    
    private func getPage()-> Int {
        page += 1
        return page
    }
    
    @objc private func didDismissPostDetailNotification(_ noti : Notification){
        OperationQueue.main.addOperation {
            self.getList()
            self.tableView.reloadData()
        }
    }
    
    @objc private func pullToRefresh(_ sender: Any) {
        getList()
        tableView.endUpdates()
        tableView.refreshControl?.endRefreshing()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        secondGetList()
    }
    
}
