//
//  SpecialTableViewCell.swift
//  GRAMO
//
//  Created by 정창용 on 2021/04/06.
//

import UIKit

// MARK: SpecialTableViewCell
class SpecialTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    
    static let specialCellIdentifier: String = "specialCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTextView.delegate = self
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
        titleTextView.text = "어떤 특별한 일인가요?"
        titleTextView.textColor = UIColor.lightGray
        detailTextView.text = "특별한 일의 설명을 적어주세요"
        detailTextView.textColor = UIColor.lightGray
            
    }

}

// MARK: UITextView
extension SpecialTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
                
        }
        
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == titleTextView {
                textView.text = "어떤 특별한 일인가요?"
                textView.textColor = UIColor.lightGray
            }
            
            if textView == detailTextView {
                textView.text = "특별한 일의 설명을 적어주세요"
                textView.textColor = UIColor.lightGray
                
            }
                
        }
            
    }
    
}


