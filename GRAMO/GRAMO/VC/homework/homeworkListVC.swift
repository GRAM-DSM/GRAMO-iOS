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

class homeworkListVC: UIViewController/* ,UITableViewDelegate, UITableViewDataSource*/ {
    
    @IBOutlet weak var assignedTableView : UITableView!
    @IBOutlet weak var allocatorTableView: UITableView!
    @IBOutlet weak var submittedTableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        assignedTableView.delegate = self
//        assignedTableView.dataSource = self
//        assignedTableView.rowHeight = 120
//
//        allocatorTableView.delegate = self
//        allocatorTableView.dataSource = self
//        allocatorTableView.rowHeight = 120
//
//        submittedTableVIew.delegate = self
//        submittedTableVIew.dataSource = self
//        submittedTableVIew.rowHeight = 120

    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
