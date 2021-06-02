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
        
        detailTextView.delegate = self
        
        placeholderSetting()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
}
    
    func placeholderSetting() {
        detailTextView.text = "사유를 적어주세요"
        detailTextView.textColor = UIColor.lightGray
    }
}

// MARK: UITextView
extension PICUTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "사유를 적어주세요"
            textView.textColor = UIColor.lightGray
        }
    }
}
