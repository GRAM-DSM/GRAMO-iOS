//
//  DetailViewController.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/18.
//

import UIKit

// MARK: DetailViewController
class DetailViewController: ViewController {
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
        appendMetadata()
        getPICU()
        getPlan()
        initRefresh()
        
        overrideUserInterfaceStyle = .light

    }
    
    @IBAction func touchUpPicuAddBtn(_ sender: UIButton) {
        let cell = picuTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PICUTableViewCell
        
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
        let cell = planTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SpecialTableViewCell
        
        httpClient.post(.createPlan(cell.detailTextView?.text ?? "", cell.titleTextView?.text ?? "", date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 201:
                do {
                    print("OK - Send notice list successfully. - createPICU")
                    self.dismiss(animated: true, completion: nil)
                    
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "Calendar2VC") as? Calendar2VC else { return }
                    vc.calendar.reloadData()
                    
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

// MARK: tableView
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let picuCell: PICUTableViewCell = tableView.dequeueReusableCell(withIdentifier: PICUTableViewCell.picuCellIdentifier, for: indexPath) as! PICUTableViewCell
            
            picuCell.nameLabel?.text = self.picu[indexPath.row].userName
            
            if indexPath.row == 0 {
                picuCell.detailLabel?.text = ""
                picuCell.detailTextView?.text = self.picu[indexPath.row].description
                
            } else {
                picuCell.detailLabel?.text = self.picu[indexPath.row].description
                picuCell.detailTextView?.text = ""
                
                picuCell.detailTextView?.isSelectable = false
                
            }
            
            return picuCell
            
        } else {
            let planCell: SpecialTableViewCell = tableView.dequeueReusableCell(withIdentifier: SpecialTableViewCell.specialCellIdentifier, for: indexPath) as! SpecialTableViewCell
            
            if indexPath.row == 0 {
                planCell.titleLabel?.text = ""
                planCell.detailLabel?.text = ""
                planCell.titleTextView?.text = self.plan[indexPath.row].title
                planCell.detailTextView?.text = self.plan[indexPath.row].description
                
            } else {
                planCell.titleLabel?.text = self.plan[indexPath.row].title
                planCell.detailLabel?.text = self.plan[indexPath.row].description
                planCell.titleTextView?.text = ""
                planCell.detailTextView?.text = ""
                
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
                        do {
                            print("OK - Send notice list successfully. - getPICU")
                            
                            self.picu.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            
                            let vc = self.storyboard?.instantiateViewController(identifier: "Calendar2VC") as? Calendar2VC
                            vc!.calendar.reloadData()

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
            
        }
        
        if tableView.tag == 2 {
            if editingStyle == .delete {
                httpClient.delete(.deletePlan(self.plan[indexPath.row].planId)).responseJSON(completionHandler: {(response) in
                    switch response.response?.statusCode {
                    case 200:
                        do {
                            print("OK - Send notice list successfully. - getPICU")
                            
                            self.plan.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            
                            guard let vc = self.storyboard?.instantiateViewController(identifier: "Calendar2VC") as? Calendar2VC else { return }
                            vc.calendar.reloadData()

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
            
        }
        
    }
    
    func setTableView() {
        picuTableView.dataSource = self
        picuTableView.delegate = self
        picuTableView.tag = 1
        
        planTableView.dataSource = self
        planTableView.delegate = self
        planTableView.tag = 2

//        specialTableView.rowHeight = UITableView.automaticDimension
//        specialTableView.estimatedRowHeight = 66
        
        picuTableView.rowHeight = 48
        planTableView.rowHeight = 66
        
    }
    
    func appendMetadata() {
        picu.append(GetPICU(picuId: 0, userName: "정창용", description: "사유를 적어주세요"))
        plan.append(GetPlan(planId: 0, title: "어떤 특별한 일인가요?", description: "특별한 일의 설명을 적어주세요"))
    
    }
    
    func getPICU() {
        httpClient.get(.getPICU(date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                do {
                    print("OK - Send notice list successfully. - getPICU")
                    
                    let data = response.data
                    let model = try JSONDecoder().decode([GetPICU].self, from: data!)

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
        
        picuTableView.reloadData()
        
    }
    
    @objc func planUpdateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        planTableView.reloadData()
        
    }
    
}

