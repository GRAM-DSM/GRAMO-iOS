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
        
        assignedTableView.rowHeight = 120
        assignedTableView.tag = 1
        
        allocatorTableView.rowHeight = 120
        allocatorTableView.tag = 2
        
        
        submittedTableVIew.rowHeight = 120
        submittedTableVIew.tag = 3
        
        getAssView()
        getSubView()
        getOrdView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAssView()
        getSubView()
        getOrdView()
        
        self.assignedTableView.reloadData()
        self.allocatorTableView.reloadData()
        self.submittedTableVIew.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return hwTeachherModel.count
        }
        
        if tableView.tag == 2 {
            return hwStudentModel.count
        }
        
        if tableView.tag == 3 {
            return hwOrderdModel.count
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
            
            cell.myNameLabel.text = hwTeachherModel[indexPath.row].teacherName
            cell.dateLabel.text = formattedDate
            cell.detailLabel.text = hwTeachherModel[indexPath.row].description
            cell.titleLabel.text = hwTeachherModel[indexPath.row].title
            cell.endDateLabel.text = hwTeachherModel[indexPath.row].endDate
            cell.majorLabel.text = hwTeachherModel[indexPath.row].major
            
            return cell
        }
        
        if tableView.tag == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SecondSectionTableViewCell
            
            let date = hwStudentModel[indexPath.row].startDate
            let finalDate = date.components(separatedBy: ["-", ":"," "])
            let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
            
            cell.recipientName.text = hwStudentModel[indexPath.row].studentName
            cell.dateLabel.text = formattedDate
            cell.detailLabel.text = hwStudentModel[indexPath.row].description
            cell.titleLabel.text = hwStudentModel[indexPath.row].title
            cell.endDateLabel.text = hwStudentModel[indexPath.row].endDate
            cell.majorLabel.text = hwStudentModel[indexPath.row].major
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! ThirdSectionTableViewCell
            
            let date = hwOrderdModel[indexPath.row].startDate
            let finalDate = date.components(separatedBy: ["-", ":"," "])
            let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
            
            cell.myNameLabel.text = hwOrderdModel[indexPath.row].teacherName
            cell.dateLabel.text = formattedDate
            cell.detailLabel.text = hwOrderdModel[indexPath.row].description
            cell.titleLabel.text = hwOrderdModel[indexPath.row].title
            cell.endDateLabel.text = hwOrderdModel[indexPath.row].endDate
            cell.majorLabel.text = hwOrderdModel[indexPath.row].major
            
            return cell
        }
    }
    
    func getAssView() {
        httpclient.get(NetworkingAPI.getAssHwList).responseJSON{(response) in
            print(response.data)
            switch response.response?.statusCode{
            case 200:
                do {
                    print("OK first")
                    let data = response.data
                    let model = try JSONDecoder().decode([HwStudent].self, from: data!)
                    print(model)
                    self.hwTeachherModel.removeAll()
                    self.hwTeachherModel.append(contentsOf: model)
                    self.assignedTableView.reloadData()
                }
                catch {
                    print(error)
                }
                
            case 400 : print("400 - BAD REQUEST")
            case 404 : print("404 - NOT FOUND")
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
                    print(model)
                    self.hwStudentModel.removeAll()
                    self.hwStudentModel.append(contentsOf: model)
                    self.allocatorTableView.reloadData()
                }
                catch{
                    print(error)
                }
                
            case 400: print("400 - BAD REQUEST")
            case 404 : print("404 - NOT FOUND")
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
                    print(model)
                    self.hwOrderdModel.removeAll()
                    self.hwOrderdModel.append(contentsOf: model)
                    self.submittedTableVIew.reloadData()
                }
                catch {
                    print(error)
                }
                
            case 400 : print("400 - BAD REQUEST")
            case 404 : print("404 - NOT FOUND")
            default : print(response.response?.statusCode)
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
