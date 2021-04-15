//
//  SpecialTableViewCell.swift
//  GRAMO
//
//  Created by 정창용 on 2021/04/06.
//

import UIKit

class SpecialTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    
    static let specialCellIdentifier: String = "specialCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

