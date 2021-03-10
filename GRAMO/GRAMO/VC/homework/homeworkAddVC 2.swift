//
//  homeworkAddVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit
import DropDown

class homeworkAddVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectMajorButton: UIButton!
    @IBOutlet weak var deadLinetTxt: UITextField!
    @IBOutlet weak var allocatorButton: UIButton!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var detailTxtView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dateLabel.adjustsFontSizeToFitWidth == false {
            dateLabel.adjustsFontSizeToFitWidth = true
        }

        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = date.string(from: Date())
        dateLabel.text = currentDate
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func selectMajor(_ sender: UIButton){
        let dropdown = DropDown()
        dropdown.dataSource = ["iOS", "안드로이드", "서버", "디자인"]
        dropdown.show()
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            selectMajorButton.setTitle("\(item)", for: .normal)
        }
    }
    
    func placeholderSetting() {
        detailTxtView.delegate = self
        detailTxtView.text = "내용을 입력하세요"
        detailTxtView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
