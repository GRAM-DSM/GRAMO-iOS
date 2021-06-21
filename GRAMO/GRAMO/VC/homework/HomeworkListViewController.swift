//
//  homeworkListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

final class HomeworkListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak private var assignedTableView : UITableView!
    @IBOutlet weak private var allocatorTableView: UITableView!
    @IBOutlet weak private var submittedTableVIew: UITableView!
    
    let httpclient = HTTPClient()
    
    private var hwTeachherModel : [HwStudent] = [HwStudent]()
    private var hwStudentModel : [HwStudent] = [HwStudent]()
    private var hwOrderdModel : [HwStudent] = [HwStudent]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1{
            guard let assignVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeworkAssignedVC") as? HomeworkAssignedViewController else {return}
            
            assignVC.id = hwTeachherModel[indexPath.row].homeworkId
            self.navigationController?.pushViewController(assignVC, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: false)
            
        }
        
        if tableView.tag == 2{
            guard let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeworkOrderedVC") as? HomeworkOrderedViewController else {return}
            
            orderVC.id = hwOrderdModel[indexPath.row].homeworkId
            self.navigationController?.pushViewController(orderVC, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return hwTeachherModel.count
        }
        
        if tableView.tag == 2 {
            return hwOrderdModel.count
        }
        
        if tableView.tag == 3 {
            return hwStudentModel.count
        }
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! FirstSectionTableViewCell
            
            let date = hwTeachherModel[indexPath.row].startDate
            let enddate = hwTeachherModel[indexPath.row].endDate
            let major = hwTeachherModel[indexPath.row].major
            
            cell.selectionStyle = .none
            
            cell.myNameLabel.text = hwTeachherModel[indexPath.row].teacherName
            cell.dateLabel.text = formatStartDate(date)
            cell.detailLabel.text = hwTeachherModel[indexPath.row].description
            cell.titleLabel.text = hwTeachherModel[indexPath.row].title
            cell.endDateLabel.text = formatEndDate(enddate)
            cell.majorLabel.text = setMajor(major)
            
            return cell
        }
        
        if tableView.tag == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SecondSectionTableViewCell
            
            let date = hwOrderdModel[indexPath.row].startDate
            let enddate = hwOrderdModel[indexPath.row].endDate
            let major = hwOrderdModel[indexPath.row].major
            
            cell.selectionStyle = .none
            
            cell.recipientName.text = hwOrderdModel[indexPath.row].studentName
            cell.dateLabel.text = formatStartDate(date)
            cell.detailLabel.text = hwOrderdModel[indexPath.row].description
            cell.titleLabel.text = hwOrderdModel[indexPath.row].title
            cell.endDateLabel.text = formatEndDate(enddate)
            cell.majorLabel.text = setMajor(major)
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! ThirdSectionTableViewCell
            
            let date = hwStudentModel[indexPath.row].startDate
            let enddate = hwStudentModel[indexPath.row].endDate
            let major = hwStudentModel[indexPath.row].major
            
            cell.myNameLabel.text = hwStudentModel[indexPath.row].teacherName
            cell.dateLabel.text = formatStartDate(date)
            cell.detailLabel.text = hwStudentModel[indexPath.row].description
            cell.titleLabel.text = hwStudentModel[indexPath.row].title
            cell.endDateLabel.text = formatEndDate(enddate)
            cell.majorLabel.text = setMajor(major)
            
            return cell
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        assignedTableView.rowHeight = 130
        assignedTableView.tag = 1
        
        allocatorTableView.rowHeight = 130
        allocatorTableView.tag = 2
        
        submittedTableVIew.rowHeight = 130
        submittedTableVIew.tag = 3
        submittedTableVIew.allowsSelection = false
        
        assignedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        allocatorTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        submittedTableVIew.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        getAssView()
        getOrdView()
        getSubView()
        
        
        assignedTableView.refreshControl = UIRefreshControl()
        allocatorTableView.refreshControl = UIRefreshControl()
        submittedTableVIew.refreshControl = UIRefreshControl()
        assignedTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh1(_:)), for: .valueChanged)
        allocatorTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh2(_:)), for: .valueChanged)
        submittedTableVIew.refreshControl?.addTarget(self, action: #selector(pullToRefresh3(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAssView()
        getOrdView()
        getSubView()
        
        self.assignedTableView.reloadData()
        self.allocatorTableView.reloadData()
        self.submittedTableVIew.reloadData()
    }
    
    
    func getAssView() {
        httpclient.get(url: HomeworkAPI.getAssHomeworkList.path(), params: nil, header: Header.token.header()).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200:
                do {
                    let data = response.data
                    let model = try JSONDecoder().decode([HwStudent].self, from: data!)
                    self.hwTeachherModel.removeAll()
                    self.hwTeachherModel.append(contentsOf: model)
                    self.assignedTableView.reloadData()
                }
                catch {
                    print(error)
                }
                
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.", message: nil)
            case 404 : print("404 - NOT FOUND assign")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(response.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    func getSubView(){
        httpclient.get(url: HomeworkAPI.getSubHomeworkList.path(), params: nil, header: Header.token.header()).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200:
                do{
                    let decoder = JSONDecoder()
                    decoder.dataDecodingStrategy = .base64
                    let data = response.data
                    let model = try decoder.decode([HwStudent].self, from: data!)
                    self.hwStudentModel.removeAll()
                    self.hwStudentModel.append(contentsOf: model)
                    self.submittedTableVIew.reloadData()
                }
                catch{
                    print(error)
                }
                
            case 400: print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.", message: nil)
            case 404 : print("404 - NOT FOUND submit")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(response.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
        
    }
    
    func getOrdView() {
        httpclient.get(url: HomeworkAPI.getOrdHomeworkList.path(), params: nil, header: Header.token.header()).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200 :
                do {
                    let data = response.data
                    let model = try JSONDecoder().decode([HwStudent].self, from: data!)
                    self.hwOrderdModel.removeAll()
                    self.hwOrderdModel.append(contentsOf: model)
                    self.allocatorTableView.reloadData()
                }
                catch {
                    print(error)
                }
                
            case 400 : print("400 - BAD REQUEST")
                self.showAlert(title: "잘못된 요청입니다.", message: nil)
            case 404 : print("404 - NOT FOUND order")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(response.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    @objc func pullToRefresh1(_ sender: Any) {
        getAssView()
        assignedTableView.endUpdates()
        assignedTableView.refreshControl?.endRefreshing()
    }
    
    @objc func pullToRefresh2(_ sender: Any) {
        getOrdView()
        allocatorTableView.endUpdates()
        allocatorTableView.refreshControl?.endRefreshing()
    }
    
    @objc func pullToRefresh3(_ sender: Any) {
        getSubView()
        submittedTableVIew.endUpdates()
        submittedTableVIew.refreshControl?.endRefreshing()
    }
}

