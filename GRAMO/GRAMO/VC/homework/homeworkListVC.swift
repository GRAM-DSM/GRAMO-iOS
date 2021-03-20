//
//  homeworkListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

var firstSection = [FirstSection]()
var secondSection = [SecondSection]()
var thirdSection = [ThirdSection]()

class homeworkListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var assignedTableView : UITableView!
    @IBOutlet weak var allocatorTableView: UITableView!
    @IBOutlet weak var submittedTableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        assignedTableView.delegate = self
        assignedTableView.dataSource = self
        assignedTableView.rowHeight = 120
        assignedTableView.tag = 1

        allocatorTableView.delegate = self
        allocatorTableView.dataSource = self
        allocatorTableView.rowHeight = 120
        allocatorTableView.tag = 2

        submittedTableVIew.delegate = self
        submittedTableVIew.dataSource = self
        submittedTableVIew.rowHeight = 120
        submittedTableVIew.tag = 3

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return firstSection.count
        }
        
        if tableView.tag == 2 {
            return secondSection.count
        }
        
        if tableView.tag == 3 {
            return thirdSection.count
        }
        
        print("numberOfRowsInSection Error")
        return 1

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FirstSectionTableViewCell
        
        if tableView.tag == 1{
            cell.myNameLabel.text = firstSection[indexPath.row].myName1
            cell.dateLabel.text = firstSection[indexPath.row].date1
            cell.detailLabel.text = firstSection[indexPath.row].detail1
            cell.titleLabel.text = firstSection[indexPath.row].title1
        }
        
        if tableView.tag == 2{
            cell.myNameLabel.text = secondSection[indexPath.row].recipient2
            cell.dateLabel.text = secondSection[indexPath.row].date2
            cell.detailLabel.text = secondSection[indexPath.row].detail2
            cell.titleLabel.text = secondSection[indexPath.row].title2
        }
        
        if tableView.tag == 3{
            cell.myNameLabel.text = thirdSection[indexPath.row].myName3
            cell.dateLabel.text = thirdSection[indexPath.row].date3
            cell.detailLabel.text = thirdSection[indexPath.row].detail3
            cell.titleLabel.text = thirdSection[indexPath.row].title3
        }

        return cell
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
