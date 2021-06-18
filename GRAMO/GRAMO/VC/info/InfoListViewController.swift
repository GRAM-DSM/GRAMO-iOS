//
//  infoListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

class InfoListViewContoller
: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let httpClient = HTTPClient()
    private var getListModel: [Notice] = [Notice]()
    private var listModel : GetNoticeList = GetNoticeList()
    
    var page : Int = 0
    var nextPage = Bool()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.notice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as! InfoTableViewCell
        
        let date = listModel.notice[indexPath.row].created_at
        let finalDate = date.components(separatedBy: ["-", ":"," "])
        let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
        
        cell.selectionStyle = .none
        
        cell.infoTitleLabel?.text = listModel.notice[indexPath.row].title
        cell.infoDetailLabel?.text = listModel.notice[indexPath.row].content
        cell.dateLabel?.text = formattedDate
        cell.writersName?.text = listModel.notice[indexPath.row].user_name
        
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
        
        print("asdf")
        getList()
        
        setNavigationBar()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostDetailNotification(_:)), name: detailVC, object: nil)
        
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func didDismissPostDetailNotification(_ noti : Notification){
        OperationQueue.main.addOperation {
            self.getList()
            self.tableView.reloadData()
        }
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        getList()
        tableView.endUpdates()
        tableView.refreshControl?.endRefreshing()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        secondGetList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("appear")
        getList()
    }
    
    func getList(){
        httpClient.get(url: NoticeAPI.getNoticeList(0).path(), params: nil, header: Header.token.header()).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200:
                print(response.data)
                let model = try? JSONDecoder().decode(GetNoticeList.self, from: response.data!)
                self.nextPage = model!.next_page
                self.listModel.notice.removeAll()
                self.listModel.notice.append(contentsOf: model!.notice)
                self.tableView.reloadData()
                
            case 404: print("404 : NOT FOUND - Notice does not exist.")
                self.showAlert(title: "오류가 발생했습니다.")
                
            case 418: self.getList()
                
            default: print("\(response.response?.statusCode)getlist" ?? "default")
                self.showAlert(title: "오류가 발생했습니다.")
            }
        }
    }
    
    func getPage()-> Int {
        page += 1
        return page
    }

    func secondGetList() {
        getPage()
        
        if nextPage == true {
            httpClient.get(url: NoticeAPI.getNoticeList(page).path(), params: nil, header: Header.token.header()).responseJSON{(response) in
                switch response.response?.statusCode{
                case 200:
                    do{
                        let data = response.data
                        let model = try JSONDecoder().decode(GetNoticeList.self, from: data!)
                        self.nextPage = model.next_page
                        self.listModel.notice.append(contentsOf: model.notice)
                        self.tableView.reloadData()
                        
                    }
                    catch{
                        
                    }
                case 404: print("404 : NOT FOUND - Notice does not exist.")
                    self.showAlert(title: "오류가 발생했습니다.")
                    
                default: print(response.response?.statusCode ?? "default")
                    self.showAlert(title: "오류가 발생했습니다.")
                }
            }
        }
        
    }
     
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }    */
    
}
