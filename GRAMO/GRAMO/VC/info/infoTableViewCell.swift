//
//  infoTableViewCell.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import UIKit

class infoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var writersName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoDetailLabel: UILabel!
    
    @IBOutlet weak var listView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        listView.layer.cornerRadius = 20.0
        listView.layer.shadowOpacity = 0.2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }
    
}
