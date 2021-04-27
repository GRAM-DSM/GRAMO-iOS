//
//  homeworkAllocatorVC.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/09.
//

import UIKit

class homeworkOrderedVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var majorButton: UIButton!
    @IBOutlet weak var selectDeadLineTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var httpClient = HTTPClient()
    var model: [HwContent] = [HwContent]()
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectDeadLineTxt.layer.cornerRadius = 8
        setNavigationBar()
        getContent(id)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton1(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton2(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteContent(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: "숙제를 삭제하시겠습니까?", message: "되돌리기는 불가능합니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "예", style: .destructive) {[self] (action) in self.deleteHw(id)}
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func returnButton(_ sender: UIButton){
        let alert = UIAlertController(title: "숙제를 반환하시겠습니까?", message: "반환된 숙제는 숙제 할당자의 할당됨으로 되돌아갑니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let rejectAction = UIAlertAction(title: "예", style: .default, handler: {[self] (action) in self.rejectedHw(id)})
        
        alert.addAction(cancelAction)
        alert.addAction(rejectAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: UIButton){
        let alert = UIAlertController(title: "숙제를 완료하시겠습니까?", message: "완료된 숙제는 삭제됩니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "예", style: .destructive, handler: {[self] (action) in self.deleteHw(id)})
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNavigationBar(){
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func getContent(_ id: Int) {
        print("GetContent 호출됨")
        httpClient.get(NetworkingAPI.getHwContent(id)).responseJSON {(res) in
            print(res.data)
            switch res.response?.statusCode {
            case 200 :
                do{
                    print("OK")
                    let data = res.data
                    let model = try JSONDecoder().decode(HwContent.self, from: data!)
                    
                    let date = model.startDate
                    let finalDate = date.components(separatedBy: ["-", ":"," "])
                    let formattedDate = finalDate[0] + "년 " + finalDate[1] + "월 " + finalDate[2] + "일"
                    
                    let endDate = model.endDate
                    let finalDate2 = endDate.components(separatedBy: ["-", ":"," "])
                    let formattedDate2 = finalDate2[0] + "년 " + finalDate2[1] + "월 " + finalDate2[2] + "일까지"
                    
                    self.selectDeadLineTxt.text = formattedDate2
                    self.dateLabel.text = formattedDate
                    self.nameLabel.text = model.studentName
                    self.majorButton.setTitle(model.major, for: .normal)
                    self.titleTxt.text = model.title
                    self.contentTxt.text = model.description
                }
                catch{
                    print("error: \(error)")
                }
                
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            default : print(res.response?.statusCode)
                
            }
        }
        
    }
    
//    func submitHw(_ id : Int) {
//        print("submit 호출됨")
//        httpClient.patch(NetworkingAPI.submitHw(id)).responseJSON {(res) in
//            switch res.response?.statusCode {
//            case 201 :
//                print("Created")
//                self.navigationController?.popViewController(animated: true)
//            case 400 : print("400 - BAD REQUEST")
//            case 401 : print("401 - Unauthorized")
//            case 403 : print("권한 없음")
//                let alert = UIAlertController(title: "권한이 없습니다.", message: nil, preferredStyle: UIAlertController.Style.alert)
//                let cancelAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//                let popAction = UIAlertAction(title: "나가기", style: .default, handler: {(action) in self.navigationController?.popViewController(animated: true)})
//                alert.addAction(cancelAction)
//                alert.addAction(popAction)
//
//                self.present(alert, animated: true, completion: nil)
//
//            case 404 : print("404 - NOT FOUND")
//            default : print(res.response?.statusCode)
//            }
//        }
//    }
    
    func deleteHw(_ id : Int) {
        print("delete 호출됨")
        httpClient.delete(NetworkingAPI.deleteHw(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 200 :
                print("OK")
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            default : print(res.response?.statusCode)
            }
        }
    }
    
    func rejectedHw(_ id: Int){
        print("rejected 호출됨")
        httpClient.patch(NetworkingAPI.rejectHw(id)).responseJSON {(res) in
            switch res.response?.statusCode {
            case 201 :
                print("OK")
                self.navigationController?.popViewController(animated: true)
            case 400 : print("400 - BAD REQUEST")
            case 401 : print("401 - Unauthorized")
            case 404 : print("404 - NOT FOUND")
            case 409 : print("409 - 권한이 없습니다.")
                let alert = UIAlertController(title: "숙제가 아직 제출되지 않았습니다.", message: "숙제를 반환할 권한이 없습니다.", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            default : print(res.response?.statusCode)
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
}
