//
//  DetailViewController.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/18.
//

import UIKit


class DetailViewController: ViewController {
    @IBOutlet weak var picuTableView: UITableView!
    @IBOutlet weak var specialTableView: UITableView!
    
    var sampleData1: [String] = []
    var sampleData2: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picuTableView.dataSource = self
        self.picuTableView.delegate = self
        self.picuTableView.tag = 1
        
        self.specialTableView.dataSource = self
        self.specialTableView.delegate = self
        self.specialTableView.tag = 2
        
//        picuTableView.rowHeight = UITableView.automaticDimension
//        picuTableView.estimatedRowHeight = 48
//
//        specialTableView.rowHeight = UITableView.automaticDimension
//        specialTableView.estimatedRowHeight = 66
        // 아니 이거 왜 안되냐고.. 시드라벋지마이러냐어더로두애밀레바
        
        self.picuTableView.rowHeight = 48
        self.specialTableView.rowHeight = 66

    }
    
    @IBAction func touchUpPicuAddBtn(_ sender: UIButton) {
        sampleData1.append("")
        // sampleData1.append(PICUCellModel.name)
        picuTableView.reloadData()
        
    }
    
    @IBAction func touchUpSpecialAddBtn(_ sender: UIButton) {
        sampleData2.append("")
        specialTableView.reloadData()
        
    }

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            print("Sample1 : \(sampleData1.count)")
            return sampleData1.count + 1

        }

        if tableView.tag == 2 {
            print("Sample2 : \(sampleData2.count)")
            return sampleData2.count + 1

        }

        return 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let picuText = self.data[indexPath.row]

        if tableView.tag == 1 {
            let picuCell: PICUTableViewCell = tableView.dequeueReusableCell(withIdentifier: PICUTableViewCell.picuCellIdentifier, for: indexPath) as! PICUTableViewCell
            
            picuCell.nameLabel?.text = "정창용"
            picuCell.detailLabel?.text = ""
            picuCell.detailTextView?.text = "사유를 적어주세요"
            
            return picuCell
            
        } else {
            let specialCell: SpecialTableViewCell = tableView.dequeueReusableCell(withIdentifier: SpecialTableViewCell.specialCellIdentifier, for: indexPath) as! SpecialTableViewCell
            
            specialCell.titleLabel?.text = ""
            specialCell.titleTextView?.text = "어떤 특별한 일인가요?"
            specialCell.detailLabel?.text = ""
            specialCell.detailTextView?.text = "특별한 일의 설명을 적어주세요"

            return specialCell

        }

    }
    
}

