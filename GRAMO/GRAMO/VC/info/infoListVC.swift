//
//  infoListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

var infoList = [InfoList]()
var nationalTableView : UITableView!

class infoListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let httpClient = HTTPClient()
    private var getListModel: [Notice] = [Notice]()
    private var listModel : GetNoticeList = GetNoticeList(notice: [Notice(id: 1, title: "asdf", content: "Asdf", user_email: "Asdf", created_at: "Asdf")])
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.notice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as! infoTableViewCell
        
        let date = DateFormatter()
        date .dateFormat = "yyyy년 MM월 dd일"
        let currentDate = date.string(from: Date())
        cell.dateLabel.text = currentDate
        
        cell.infoTitleLabel?.text = listModel.notice[indexPath.row].title
        cell.infoDetailLabel?.text = listModel.notice[indexPath.row].content
        cell.dateLabel?.text = listModel.notice[indexPath.row].created_at
        //cell.writersName?.text = listModel.notice[indexPath.row].name
        
        return cell
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 130
        
        getList()
        nationalTableView = tableView
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func getList(){
        print("호출됨")
        httpClient.get(NetworkingAPI.getNoticeList(1, 100)).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200: print("OK - Send notice list successfully.")
                do{
                    print(response.data)
                    guard let data = response.data else {return}
                    guard let model = try? JSONDecoder().decode(GetNoticeList.self, from: data) else {return}
                    print(model.notice)
                    self.listModel.notice.append(contentsOf: model.notice)
                    self.tableView.reloadData()
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
    }
    */

}
