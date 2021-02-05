//
//  infoTableViewCell.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

class infoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoDetailLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var listView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.layer.cornerRadius = 3.0
        listView.layer.cornerRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
