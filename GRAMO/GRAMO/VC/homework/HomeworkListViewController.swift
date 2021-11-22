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
            
//            cell.myNameLabel.text = "이가영"
//            cell.dateLabel.text = "2021년 11월 14일"
//            cell.detailLabel.text = "RxSwift 공부해오기"
//            cell.titleLabel.text = "11월 둘째주 숙제"
//            cell.endDateLabel.text = "2021년 11월 21일"
//            cell.majorLabel.text = "iOS"
            
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
            
//            cell.recipientName.text = "정창용"
//            cell.dateLabel.text = "2021년 11월 17일"
//            cell.detailLabel.text = "로그인 회원가입 부분 빼고 코드리뷰해주세요"
//            cell.titleLabel.text = "컬러 끝내오기"
//            cell.endDateLabel.text = "2021년 11월 20일"
//            cell.majorLabel.text = "iOS"
            
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
//            
//            cell.myNameLabel.text = "이가영"
//            cell.dateLabel.text = "2021년 11월 10일"
//            cell.detailLabel.text = "코드리뷰 수정해오기"
//            cell.titleLabel.text = "PR에 달아놓은 코드리뷰 바탕으로 수정해오기"
//            cell.endDateLabel.text = "2021년 11월 12일"
//            cell.majorLabel.text = "iOS"
            
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
        
        //allocatorTableView.isHidden = true
        
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
        
        assignedTableView.reloadData()
        allocatorTableView.reloadData()
        submittedTableVIew.reloadData()
        
//        if hidden == 3 {
//            allocatorTableView.isHidden = false
//        }
    }
    
    
    private func getAssView() {
        httpclient.get(url: HomeworkAPI.getAssHomeworkList.path(), params: nil, header: Header.accessToken.header()).responseJSON{[unowned self](response) in
            print(response.response?.statusCode)
            switch response.response?.statusCode{
            case 200:
                let model = try? JSONDecoder().decode([HwStudent].self, from: response.data!)
                hwTeachherModel.removeAll()
                hwTeachherModel.append(contentsOf: model!)
                assignedTableView.reloadData()
                
            case 400 :
                showAlert(title: "잘못된 요청입니다.", message: nil)
                
            case 401:
                print("401 - getAssHomeworkList")
                tokenRefresh()
                
            case 404 :
                showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(response.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    private func getSubView(){
        httpclient.get(url: HomeworkAPI.getSubHomeworkList.path(), params: nil, header: Header.accessToken.header()).responseJSON{[unowned self](response) in
            print(response.response?.statusCode)
            switch response.response?.statusCode{
            case 200:
                
                let decoder = JSONDecoder()
                decoder.dataDecodingStrategy = .base64
                let model = try? decoder.decode([HwStudent].self, from: response.data!)
                self.hwStudentModel.removeAll()
                self.hwStudentModel.append(contentsOf: model!)
                self.submittedTableVIew.reloadData()
                
            case 400:
                showAlert(title: "잘못된 요청입니다.", message: nil)
                
            case 401:
                print("401 - getSubHomeworkList")
                tokenRefresh()
                
            case 404 :
                showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(response.response?.statusCode ?? "default")
                self.showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
        
    }
    
    private func getOrdView() {
        httpclient.get(url: HomeworkAPI.getOrdHomeworkList.path(), params: nil, header: Header.accessToken.header()).responseJSON{[unowned self](response) in
            print(response.response?.statusCode)
            switch response.response?.statusCode{
            case 200 :
                
                let model = try? JSONDecoder().decode([HwStudent].self, from: response.data!)
                hwOrderdModel.removeAll()
                hwOrderdModel.append(contentsOf: model!)
                allocatorTableView.reloadData()
                
                
            case 400 :
                showAlert(title: "잘못된 요청입니다.", message: nil)
                
            case 401:
                print("401 - getOrdHomeworkList")
                tokenRefresh()
                
            case 404 :
                showAlert(title: "오류가 발생했습니다.", message: nil)
            default : print(response.response?.statusCode ?? "default")
                showAlert(title: "오류가 발생했습니다.", message: nil)
            }
        }
    }
    
    @objc private func pullToRefresh1(_ sender: Any) {
        getAssView()
        assignedTableView.endUpdates()
        assignedTableView.refreshControl?.endRefreshing()
    }
    
    @objc private func pullToRefresh2(_ sender: Any) {
        getOrdView()
        allocatorTableView.endUpdates()
        allocatorTableView.refreshControl?.endRefreshing()
    }
    
    @objc private func pullToRefresh3(_ sender: Any) {
        getSubView()
        submittedTableVIew.endUpdates()
        submittedTableVIew.refreshControl?.endRefreshing()
    }
}

