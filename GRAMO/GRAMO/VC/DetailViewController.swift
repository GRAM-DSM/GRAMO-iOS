//
//  DetailViewController.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/18.
//

import UIKit

class DetailViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var picuTableView: UITableView!
    let cellIdentifier: String = "picuCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picuTableView.dataSource = self
        self.picuTableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let picuCell: PICUTableViewCell = tableView.dequeueReusableCell(withIdentifier: picuCell, for: indexPath) as! PICUTableViewCell
        
        let text: String = "Test"
        
        return picuCell
        
    }

}

