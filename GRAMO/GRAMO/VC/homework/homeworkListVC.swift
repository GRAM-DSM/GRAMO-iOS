//
//  homeworkListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

class homeworkListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var assignedTableView : UITableView!
    @IBOutlet weak var allocatorTableView: UITableView!
    @IBOutlet weak var submittedTableVIew: UITableView!
    
    let httpclient = HTTPClient()
    
    private var hwTeachherModel : [HwStudent] = [HwStudent]()
    
    private var hwStudentModel : [HwStudent] = [HwStudent]()
    
    private var hwOrderdModel : [HwStudent] = [HwStudent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNavigationBar()
        
        assignedTableView.rowHeight = 130
        assignedTableView.tag = 1
        
        allocatorTableView.rowHeight = 130
        allocatorTableView.tag = 2
        
        submittedTableVIew.rowHeight = 130
        submittedTableVIew.tag = 3
        
        assignedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        allocatorTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        submittedTableVIew.separatorStyle = UITableViewCell.SeparatorStyle.none

        getAssView()
        getOrdView()
        getSubView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAssView()
        getOrdView()
        getSubView()
        
        self.assignedTableView.reloadData()
        self.allocatorTableView.reloadData()
        self.submittedTableVIew.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1{
            guard let assignVC = self.storyboard?.instantiateViewController(withIdentifier: "homeworkAssignedVC") as? homeworkAssignedVC else {return}
            
            assignVC.id = hwTeachherModel[indexPath.row].homeworkId
            print(hwTeachherModel[indexPath.row].homeworkId)
            self.navigationController?.pushViewController(assignVC, animated: true)
            
        }
        
        if tableView.tag == 2{
            guard let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "homeworkOrderedVC") as? homeworkOrderedVC else {return}
            
            orderVC.id = hwOrderdModel[indexPath.row].homeworkId
            print(hwOrderdModel[indexPath.row].homeworkId)
            self.navigationController?.pushViewController(orderVC, animated: true)
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
        
        print("numberOfRowsInSection Error")
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! FirstSectionTableViewCell
            
            let date = hwTeachherModel[indexPath.row].startDate
            let finalDate = date.components(separatedBy: ["-", ":"," "])
            let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
            
            let enddate = hwTeachherModel[indexPath.row].endDate
            let finalDate2 = enddate.components(separatedBy: ["-", ":"," "])
            let formattedDate2 = finalDate2[0] + "년 " + finalDate2[1] + "월 " + finalDate2[2] + "일"
            
            cell.myNameLabel.text = hwTeachherModel[indexPath.row].teacherName
            cell.dateLabel.text = formattedDate
            cell.detailLabel.text = hwTeachherModel[indexPath.row].description
            cell.titleLabel.text = hwTeachherModel[indexPath.row].title
            cell.endDateLabel.text = formattedDate2
            cell.majorLabel.text = hwTeachherModel[indexPath.row].major
            
            return cell
        }
        
        if tableView.tag == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SecondSectionTableViewCell
            
            let date = hwOrderdModel[indexPath.row].startDate
            let finalDate = date.components(separatedBy: ["-", ":"," "])
            let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
            
            let enddate = hwOrderdModel[indexPath.row].endDate
            let finalDate2 = enddate.components(separatedBy: ["-", ":"," "])
            let formattedDate2 = finalDate2[0] + "년 " + finalDate2[1] + "월 " + finalDate2[2] + "일"
            
            cell.recipientName.text = hwOrderdModel[indexPath.row].studentName
            cell.dateLabel.text = formattedDate
            cell.detailLabel.text = hwOrderdModel[indexPath.row].description
            cell.titleLabel.text = hwOrderdModel[indexPath.row].title
            cell.endDateLabel.text = formattedDate2
            cell.majorLabel.text = hwOrderdModel[indexPath.row].major
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! ThirdSectionTableViewCell
            
            let date = hwStudentModel[indexPath.row].startDate
            let finalDate = date.components(separatedBy: ["-", ":"," "])
            let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
            
            let enddate = hwStudentModel[indexPath.row].endDate
            let finalDate2 = enddate.components(separatedBy: ["-", ":"," "])
            let formattedDate2 = finalDate2[0] + "년 " + finalDate2[1] + "월 " + finalDate2[2] + "일"
            
            cell.myNameLabel.text = hwStudentModel[indexPath.row].teacherName
            cell.dateLabel.text = formattedDate
            cell.detailLabel.text = hwStudentModel[indexPath.row].description
            cell.titleLabel.text = hwStudentModel[indexPath.row].title
            cell.endDateLabel.text = formattedDate2
            cell.majorLabel.text = hwStudentModel[indexPath.row].major
            
            
            return cell
        }
    }
    
    func getAssView() {
        httpclient.get(NetworkingAPI.getAssHwList).responseJSON{(response) in
//            print(response.data)
            switch response.response?.statusCode{
            case 200:
                do {
                    print("OK first")
                    let data = response.data
                    let model = try JSONDecoder().decode([HwStudent].self, from: data!)
//                    print(model)
                    self.hwTeachherModel.removeAll()
                    self.hwTeachherModel.append(contentsOf: model)
                    self.assignedTableView.reloadData()
                }
                catch {
                    print(error)
                }
                
            case 400 : print("400 - BAD REQUEST")
            case 404 : print("404 - NOT FOUND assign")
            default : print(response.response?.statusCode)
            }
        }
    }
    
    func getSubView(){
        httpclient.get(NetworkingAPI.getSubHwList).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200:
                do{
                    print("OK second")
                    let decoder = JSONDecoder()
                    decoder.dataDecodingStrategy = .base64
                    let data = response.data
                    let model = try decoder.decode([HwStudent].self, from: data!)
//                    print(model)
                    self.hwStudentModel.removeAll()
                    self.hwStudentModel.append(contentsOf: model)
                    self.submittedTableVIew.reloadData()
                }
                catch{
                    print(error)
                }
                
            case 400: print("400 - BAD REQUEST")
            case 404 : print("404 - NOT FOUND submit")
            default : print(response.response?.statusCode)
            }
        }
        
    }
    
    func getOrdView() {
        httpclient.get(NetworkingAPI.getOrdHwList).responseJSON{(response) in
            switch response.response?.statusCode{
            case 200 :
                do {
                    print("OK third")
                    let data = response.data
                    let model = try JSONDecoder().decode([HwStudent].self, from: data!)
//                    print(model)
                    self.hwOrderdModel.removeAll()
                    self.hwOrderdModel.append(contentsOf: model)
                    self.allocatorTableView.reloadData()
                }
                catch {
                    print(error)
                }
                
            case 400 : print("400 - BAD REQUEST")
            case 404 : print("404 - NOT FOUND order")
            default : print(response.response?.statusCode)
            }
        }
    }
    
    func setNavigationBar(){
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
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
