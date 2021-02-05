//
//  infoListVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

var infoList = [InfoList]()

class infoListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as! infoTableViewCell
        
        cell.dateLabel?.text = infoList[indexPath.row].date
        cell.infoTitleLabel?.text = infoList[indexPath.row].title
        cell.infoDetailLabel?.text = infoList[indexPath.row].subtitle
        
        return cell
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120

        // Do any additional setup after loading the view.
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
