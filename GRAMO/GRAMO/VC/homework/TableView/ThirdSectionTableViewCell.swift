//
//  ThirdSectionTableViewCell.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/15.
//

import UIKit

class ThirdSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var myNameLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var detailLabel : UILabel!
    
    @IBOutlet weak var listView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        listView.layer.cornerRadius = 3.0
        listView.layer.shadowOpacity = 2.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
