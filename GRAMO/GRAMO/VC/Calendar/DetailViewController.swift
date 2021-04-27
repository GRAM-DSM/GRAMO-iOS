//
//  DetailViewController.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/18.
//

import UIKit

// MARK: DetailViewController
class DetailViewController: ViewController, UITextViewDelegate {
    @IBOutlet weak var picuTableView: UITableView!
    @IBOutlet weak var planTableView: UITableView!
    
    private let httpClient = HTTPClient()
    
    private var picu = [GetPICU]()
    private var plan = [GetPlan]()
    private var calendar = [Calendar2VC]()
    
    private let refreshControl = UIRefreshControl()
    
    public var date = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        appendMetadata(num: 0)
        getPICU()
        getPlan()
        initRefresh()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)

    }
    
    @IBAction func touchUpPicuAddBtn(_ sender: UIButton) {
        let cell = picuTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PICUTableViewCell
        
        httpClient.post(.createPICU(cell.detailTextView?.text ?? "", date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 201:
                print("OK - Send notice list successfully. - createPICU")
                self.dismiss(animated: true, completion: nil)
                
            case 400:
                self.showToast(message: "권한 없음")
                
            case 403:
                print("403 : Token Token Token Token - createPICU")
                    
            case 404:
                print("404 : NOT FOUND - Notice does not exist. - createPICU")
                    
            default:
                print(response.response?.statusCode)
                print(response.error)
                    
            }
            
        })
        
    }
    
    @IBAction func touchUpSpecialAddBtn(_ sender: UIButton) {
        let cell = planTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SpecialTableViewCell
        
        httpClient.post(.createPlan(cell.detailTextView?.text ?? "", cell.titleTextView?.text ?? "", date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 201:
                print("OK - Send notice list successfully. - createPlan")
                self.dismiss(animated: true, completion: nil)
                
            case 400:
                self.showToast(message: "권한 없음")
                
            case 403:
                print("403 : Token Token Token Token - createPlan")
                
            case 404:
                print("404 : NOT FOUND - Notice does not exist. - createPlan")
                
            default:
                print(response.response?.statusCode)
                print(response.error)
                
            }
            
        })
        
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) { let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        
        })
        
    }

}

// MARK: tableView
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let picuCell: PICUTableViewCell = tableView.dequeueReusableCell(withIdentifier: PICUTableViewCell.picuCellIdentifier, for: indexPath) as! PICUTableViewCell
            
            print(self.picu)
            picuCell.nameLabel?.text = self.picu[indexPath.row].userName
            
            if indexPath.row == 0 {
                picuCell.detailLabel?.text = ""
                picuCell.detailTextView?.text = picu[indexPath.row].description
                
            } else {
                picuCell.detailLabel?.text = self.picu[indexPath.row].description
                picuCell.detailTextView?.text.removeAll()
                
                picuCell.detailTextView?.isSelectable = false
                
            }
            
            return picuCell
            
        } else {
            let planCell: SpecialTableViewCell = tableView.dequeueReusableCell(withIdentifier: SpecialTableViewCell.specialCellIdentifier, for: indexPath) as! SpecialTableViewCell
            
            if indexPath.row == 0 {
                planCell.titleLabel?.text = ""
                planCell.detailLabel?.text = ""
                planCell.titleTextView?.text = self.plan[indexPath.row].description
                planCell.detailTextView?.text = self.plan[indexPath.row].description
                
            } else {
                planCell.titleLabel?.text = self.plan[indexPath.row].title
                planCell.detailLabel?.text = self.plan[indexPath.row].description
                planCell.titleTextView?.text = ""
                planCell.detailTextView?.text  = ""
                
                planCell.titleTextView.isSelectable = false
                planCell.detailTextView.isSelectable = false
            
            }

            return planCell

        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return picu.count

        }
        
        if tableView.tag == 2 {
            return plan.count

        }

        return 0

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if editingStyle == .delete {
                httpClient.delete(.deletePICU(self.picu[indexPath.row].picuId)).responseJSON(completionHandler: {(response) in
                    switch response.response?.statusCode {
                    case 200:
                        print("OK - Send notice list successfully. - getPICU")
                            
                        self.picu.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                            
                        self.showToast(message: "PICU 삭제 성공!")
                        
                    case 401:
                        self.showToast(message: "권한이 없습니다")
                        
                    case 403:
                        print("403 : Token Token Token Token - getPICU")
                    
                    case 404:
                        print("404 : NOT FOUND - Notice does not exist. - getPICU")

                    default:
                        print(response.response?.statusCode)
                        print(response.error)
                    
                    }
                    
                })
                
            }
            
        }
        
        if tableView.tag == 2 {
            if editingStyle == .delete {
                httpClient.delete(.deletePlan(self.plan[indexPath.row].planId)).responseJSON(completionHandler: {(response) in
                    switch response.response?.statusCode {
                    case 200:
                        print("OK - Send notice list successfully. - getPICU")
                            
                        self.plan.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                            
                        self.showToast(message: "Plan 삭제 성공!")
                        
                    case 401:
                        self.showToast(message: "권한이 없습니다")

                    case 403:
                        print("403 : Token Token Token Token - getPICU")
                    
                    case 404:
                        print("404 : NOT FOUND - Notice does not exist. - getPICU")

                    default:
                        print(response.response?.statusCode)
                        print(response.error)
                    
                    }
                    
                })
                
            }
            
        }
        
    }
    
    func setTableView() {
        picuTableView.dataSource = self
        picuTableView.delegate = self
        picuTableView.tag = 1
        
        planTableView.dataSource = self
        planTableView.delegate = self
        planTableView.tag = 2
        
        picuTableView.rowHeight = 48
        planTableView.rowHeight = 66
        
    }
    
    func appendMetadata(num: Int) {
        switch num {
        case 1:
            picu.append(GetPICU(picuId: 0, userName: "정창용", description: "사유를 적어주세요"))
            
        case 2:
            plan.append(GetPlan(planId: 0, title: "어떤 특별한 일인가요?", description: "특별한 일의 설명을 적어주세요"))
            
        default:
            picu.append(GetPICU(picuId: 0, userName: "정창용", description: "사유를 적어주세요"))
            plan.append(GetPlan(planId: 0, title: "어떤 특별한 일인가요?", description: "특별한 일의 설명을 적어주세요"))
            
        }
    
    }
    
    func getPICU() {
        httpClient.get(.getPICU(date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                do {
                    print("OK - Send notice list successfully. - getPICU")
                    
                    let data = response.data
                    let model = try JSONDecoder().decode([GetPICU].self, from: data!)

                    self.picu.removeAll()
                    
                    self.appendMetadata(num: 1)
                    
                    self.picu.append(contentsOf: model)
                    self.picuTableView.reloadData()

                } catch {
                    print("Error: \(error)")

                }
                
            case 403:
                print("403 : Token Token Token Token - getPICU")
            
            case 404:
                print("404 : NOT FOUND - Notice does not exist. - getPICU")

            default:
                print(response.response?.statusCode)
                print(response.error)
            
            }
            
        })
            
    }
    
    func getPlan() {
        httpClient.get(.getPlan(date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                do {
                    print("OK - Send notice list successfully. - getPICU")
                    
                    let data = response.data
                    let model = try JSONDecoder().decode([GetPlan].self, from: data!)

                    self.plan.removeAll()
                    
                    self.appendMetadata(num: 2)
                    
                    self.plan.append(contentsOf: model)
                    self.planTableView.reloadData()

                } catch {
                    print("Error: \(error)")

                }

            case 403:
                print("403 : Token Token Token Token - getPICU")
            
            case 404:
                print("404 : NOT FOUND - Notice does not exist. - getPICU")

            default:
                print(response.response?.statusCode)
                print(response.error)
            
            }
            
        })
        
    }
    
    func initRefresh() {
        let picuRefresh = UIRefreshControl()
        let planRefresh = UIRefreshControl()
        
        picuRefresh.addTarget(self, action: #selector(picuUpdateUI(refresh:)), for: .valueChanged)
        picuRefresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        planRefresh.addTarget(self, action: #selector(planUpdateUI(refresh:)), for: .valueChanged)
        planRefresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        picuTableView.refreshControl = picuRefresh
        planTableView.refreshControl = planRefresh
        
    }
    
    @objc func picuUpdateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        getPICU()
        
    }
    
    @objc func planUpdateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        getPlan()
        
    }
    
}

