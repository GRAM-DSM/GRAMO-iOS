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
    
    var off_set : Int = 0
    var limit_num : Int = 10
    var nextPage = Bool()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.notice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as! InfoTableViewCell
        
        let date = listModel.notice[indexPath.row].created_at
        let finalDate = date.components(separatedBy: ["-", ":"," "])
        let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
        
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 130
        
        getList()
        
        setNavigationBar()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
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
        super.viewWillAppear(true)
        
        getList()
        self.tableView.reloadData()
    }
    
    func getList(){
        httpClient.get(NetworkingAPI.getNoticeList(0, 10)).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200: 
                do{
                    let data = response.data
                    let model = try JSONDecoder().decode(GetNoticeList.self, from: data!)
                    self.nextPage = model.next_page
                    self.listModel.notice.removeAll()
                    self.listModel.notice.append(contentsOf: model.notice)
                    self.tableView.reloadData()
                }
                catch{
                    print(error)
                }
            case 404: print("404 : NOT FOUND - Notice does not exist.")
            default: print(response.response?.statusCode)
            }
        }
    }
    
    func getOffSet()-> Int {
        self.off_set += self.limit_num
        return off_set
    }
    
    func secondGetList() {
        getOffSet()
        if nextPage == true {
            httpClient.get(NetworkingAPI.getNoticeList(off_set, limit_num)).responseJSON{(response) in
                switch response.response?.statusCode{
                case 200:
                    do{
                        let data = response.data
                        let model = try JSONDecoder().decode(GetNoticeList.self, from: data!)
                        self.nextPage = model.next_page
                        //                        self.listModel.notice.removeAll()
                        self.listModel.notice.append(contentsOf: model.notice)
                        self.tableView.reloadData()
                        
                    }
                    catch{
                        print(error)
                    }
                case 404: print("404 : NOT FOUND - Notice does not exist.")
                default: print(response.response?.statusCode)
                }
            }
        }
        
        else {
            let alert = UIAlertController(title: "더 이상 불러올 공지사항이 없습니다.", message: nil, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
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
