//
//  infoListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

var nationalTableView : UITableView!

class infoListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let httpClient = HTTPClient()
    private var getListModel: [Notice] = [Notice]()
    private var listModel : GetNoticeList = GetNoticeList()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.notice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as! infoTableViewCell
        
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
        
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "infoDetailVC") as? infoDetailVC else { return }
        
        detailVC.id = listModel.notice[indexPath.row].id
        print(listModel.notice[indexPath.row].id)
        self.present(detailVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 130
        
        nationalTableView = tableView
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getList()
        self.tableView.reloadData()
    }
    
    func getList(){
        print("호출됨")
        httpClient.get(NetworkingAPI.getNoticeList(1, 100)).responseJSON{(response) in
            print(response.data)
            switch response.response?.statusCode{
            case 200: print("OK - Send notice list successfully.")
                do{
                    guard let data = response.data else {return}
                    guard let model = try? JSONDecoder().decode(GetNoticeList.self, from: data) else {return}
                    print(model.notice)
                    self.listModel.notice.removeAll()
                    self.listModel.notice.append(contentsOf: model.notice)
                    self.tableView.reloadData()
                    print("reloadData")
                    
                }
                catch{
                    print("error")
                    print(error)
                }
            case 404: print("404 : NOT FOUND - Notice does not exist.")
            default: print(response.response?.statusCode)
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
