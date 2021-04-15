//
//  PICUTableViewCell.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/29.
//

import UIKit

class PICUTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var detailTextView: UITextView!
    
    static let picuCellIdentifier: String = "picuCell"
    
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

