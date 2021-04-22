//
//  DetailViewController.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/18.
//

import UIKit

class DetailViewController: ViewController {
    @IBOutlet weak var picuTableView: UITableView!
    @IBOutlet weak var specialTableView: UITableView!
    
    let httpClient = HTTPClient()
    
    private var getPlan: [GetPlan] = []
    private var getPICU: [GetPICU] = []
    
    var picuIdArray: [Int] = [0]
    var picuUserNameArray: [String] = [""]
    var picuDescriptionArray: [String] = [""]
    var planTitleArray: [String] = [""]
    var planDescriptionArray: [String] = [""]
    
    var date = String()
    var tellMeYesOrNo1: Bool = true
    var tellMeYesOrNo2: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picuTableView.dataSource = self
        self.picuTableView.delegate = self
        self.picuTableView.tag = 1
        
        
        self.specialTableView.dataSource = self
        self.specialTableView.delegate = self
        self.specialTableView.tag = 2

//        specialTableView.rowHeight = UITableView.automaticDimension
//        specialTableView.estimatedRowHeight = 66
        
        self.picuTableView.rowHeight = 48
        self.specialTableView.rowHeight = 66

    }
    
    @IBAction func touchUpPicuAddBtn(_ sender: UIButton) {
        let cell = picuTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PICUTableViewCell
        
        print(cell.detailTextView.text)
        
        httpClient.post(.createPICU(cell.detailTextView?.text ?? "", date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 201:
                print("OK - Send notice list successfully. - createPICU")
                    
                self.dismiss(animated: true, completion: nil)
                
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
        httpClient.post(.createPlan("안녕하세요", "반갑습니다", date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                do {
                    print("OK - Send notice list successfully. - createPICU")
                    
                    self.navigationController?.popViewController(animated: true)
                    
                } catch {
                    print("Error: \(error)")
                    
                }
                
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

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let picuCell: PICUTableViewCell = tableView.dequeueReusableCell(withIdentifier: PICUTableViewCell.picuCellIdentifier, for: indexPath) as! PICUTableViewCell
            
            httpClient.get(.getPICU(date)).responseJSON(completionHandler: {(response) in
                switch response.response?.statusCode {
                case 200:
                    do {
                        print("OK - Send notice list successfully. - getPICU")
                        
                        let data = response.data
                        let model = try JSONDecoder().decode([GetPICU].self, from: data!)
                        var num: Int = 0
                        
                        self.getPICU = model
                        
                        if self.tellMeYesOrNo1 {
                            for _ in self.getPICU {
                                self.picuIdArray.append(self.getPICU[num].picuId)
                                self.picuUserNameArray.append(self.getPICU[num].userName)
                                self.picuDescriptionArray.append(self.getPICU[num].description)
                                
                                num += 1
                                
                            }
                            
                            self.tellMeYesOrNo1 = false
                            self.picuTableView.reloadData()
                            
                        }
                        
                        if indexPath.row == 0 {
                            picuCell.nameLabel?.text = "정창용"
                            picuCell.detailLabel?.text = ""
                            picuCell.detailTextView?.text = "사유를 적어주세요"
                            
                        } else {
                            picuCell.nameLabel?.text = self.picuUserNameArray[indexPath.row]
                            picuCell.detailLabel?.text = self.picuDescriptionArray[indexPath.row]
                            picuCell.detailTextView?.text = ""
                            
                        }
                        
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
            
            return picuCell
            
        } else {
            let specialCell: SpecialTableViewCell = tableView.dequeueReusableCell(withIdentifier: SpecialTableViewCell.specialCellIdentifier, for: indexPath) as! SpecialTableViewCell
            
            httpClient.get(.getPlan(date)).responseJSON(completionHandler: {(response) in
                switch response.response?.statusCode {
                case 200:
                    do {
                        print("OK - Send notice list successfully. - getPlan")
                        
                        let data = response.data
                        let model = try JSONDecoder().decode([GetPlan].self, from: data!)
                        var num: Int = 0
                        
                        self.getPlan = model
                        
                        if self.tellMeYesOrNo2 {
                            for _ in self.getPlan {
                                self.planTitleArray.append(self.getPlan[indexPath.row].title)
                                self.planDescriptionArray.append(self.getPlan[indexPath.row].description)
                                
                            }
                            
                            self.tellMeYesOrNo2 = false
                            self.specialTableView.reloadData()
                            
                        }
                        
                        if indexPath.row == 0 {
                            specialCell.titleLabel?.text = ""
                            specialCell.detailLabel?.text = ""
                            specialCell.titleTextView?.text = "어떤 특별한 일인가요?"
                            specialCell.detailTextView?.text = "특별한 일의 설명을 적어주세요"
                            
                        } else {
                            specialCell.titleLabel?.text = self.planTitleArray[indexPath.row]
                            specialCell.detailLabel?.text = self.planDescriptionArray[indexPath.row]
                            specialCell.titleTextView?.text = ""
                            specialCell.detailTextView?.text = ""
                            
                        }
                        
                    } catch {
                        print("Error: \(error)")
                        
                    }
                    
                case 403:
                    print("403 : Token Token Token Token - getPlan")
                    
                case 404:
                    print("404 : NOT FOUND - Notice does not exist. - getPlan")
                    
                default:
                    print(response.response?.statusCode)
                    print(response.error)
                
                }
                
            })

            return specialCell

        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            print("PICU : \(picuUserNameArray.count)")
            return picuUserNameArray.count

        }
        
        if tableView.tag == 2 {
            print("Plan : \(planTitleArray.count)")
            return planTitleArray.count

        }

        return 0

    }
    
}

