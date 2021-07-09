//
//  DetailViewController.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/18.
//

import UIKit

final class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet private weak var picuTableView: UITableView!
    @IBOutlet private weak var planTableView: UITableView!
    
    private let httpClient = HTTPClient()
    
    private var picu = picuContentResponses()
    private var plan = planContentResponses()
    
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
    
    @IBAction private func touchUpPicuAddBtn(_ sender: UIButton) {
        let cell = picuTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PICUTableViewCell
        createPICU(description: cell.detailTextView.text, date: date)
    }
    
    @IBAction private func touchUpSpecialAddBtn(_ sender: UIButton) {
        let cell = planTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SpecialTableViewCell
        createPlan(title: cell.titleTextView.text, description: cell.detailTextView.text, date: date)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let picuCell: PICUTableViewCell = tableView.dequeueReusableCell(withIdentifier: PICUTableViewCell.picuCellIdentifier, for: indexPath) as! PICUTableViewCell
            
            print(self.picu)
            picuCell.nameLabel?.text = self.picu.picuContentResponses[indexPath.row].userName
            
            picuCell.selectionStyle = .none
            
            if indexPath.row == 0 {
                picuCell.detailLabel?.text = ""
                picuCell.detailTextView?.text = picu.picuContentResponses[indexPath.row].description
            } else {
                picuCell.detailLabel?.text = self.picu.picuContentResponses[indexPath.row].description
                picuCell.detailTextView?.text.removeAll()
                
                picuCell.detailTextView?.isSelectable = false
            }
            
            return picuCell
        } else {
            let planCell: SpecialTableViewCell = tableView.dequeueReusableCell(withIdentifier: SpecialTableViewCell.specialCellIdentifier, for: indexPath) as! SpecialTableViewCell
            
            planCell.selectionStyle = .none
            
            if indexPath.row == 0 {
                planCell.titleLabel?.text = ""
                planCell.detailLabel?.text = ""
                planCell.titleTextView?.text = self.plan.planContentResponses[indexPath.row].description
                planCell.detailTextView?.text = self.plan.planContentResponses[indexPath.row].description
            } else {
                planCell.titleLabel?.text = self.plan.planContentResponses[indexPath.row].title
                planCell.detailLabel?.text = self.plan.planContentResponses[indexPath.row].description
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
            return picu.picuContentResponses.count
        }
        
        if tableView.tag == 2 {
            return plan.planContentResponses.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if editingStyle == .delete {
                httpClient
                    .delete(url: CalendarAPI.deletePICU(picu.picuContentResponses[indexPath.row].picuId).path(), params: nil, header: Header.token.header())
                    .responseJSON(completionHandler: {[unowned self](response) in
                        switch response.response?.statusCode {
                        case 200:
                            print("OK - getPICU")
                            
                            picu.picuContentResponses.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            
                            showToast(message: "PICU 삭제 성공!")
                            
                        case 403:
                            print("403 : Forbidden - getPICU")
                            showToast(message: "권한이 없습니다")
                            
                        case 404:
                            print("404 : NOT FOUND - Notice does not exist. - getPICU")
                            
                        default:
                            print(response.response?.statusCode ?? "default")
                            print(response.error ?? "default")
                        }
                    })
            }
        }
        
        if tableView.tag == 2 {
            if editingStyle == .delete {
                httpClient
                    .delete(url: CalendarAPI.deletePlan(plan.planContentResponses[indexPath.row].planId).path(), params: nil, header: Header.token.header())
                    .responseJSON(completionHandler: {[unowned self](response) in
                        switch response.response?.statusCode {
                        case 200:
                            print("OK - getPICU")
                            
                            plan.planContentResponses.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            
                            showToast(message: "Plan 삭제 성공!")
                            
                        case 403:
                            print("403 : Forbidden - getPICU")
                            showToast(message: "권한이 없습니다")
                            
                        case 404:
                            print("404 : NOT FOUND - Notice does not exist. - getPICU")
                            
                        default:
                            print(response.response?.statusCode ?? "default")
                            print(response.error ?? "default")
                        }
                    })
            }
        }
    }
    
    private func setTableView() {
        picuTableView.dataSource = self
        picuTableView.delegate = self
        picuTableView.tag = 1
        
        planTableView.dataSource = self
        planTableView.delegate = self
        planTableView.tag = 2
        
        picuTableView.rowHeight = 48
        planTableView.rowHeight = 66
        
    }
    
    private func appendMetadata(num: Int) {
        switch num {
        case 1:
            picu.picuContentResponses.append(GetPICU(picuId: 0, userName: UserDefaults.standard.object(forKey: "nickname") as! String, description: "사유를 적어주세요"))
            
        case 2:
            plan.planContentResponses.append(GetPlan(planId: 0, title: "어떤 특별한 일인가요?", description: "특별한 일의 설명을 적어주세요"))
            
        default:
            picu.picuContentResponses.append(GetPICU(picuId: 0, userName: UserDefaults.standard.object(forKey: "nickname") as! String, description: "사유를 적어주세요"))
            plan.planContentResponses.append(GetPlan(planId: 0, title: "어떤 특별한 일인가요?", description: "특별한 일의 설명을 적어주세요"))
        }
    }
    
    private func initRefresh() {
        let picuRefresh = UIRefreshControl()
        let planRefresh = UIRefreshControl()
        
        picuRefresh.addTarget(self, action: #selector(picuUpdateUI(refresh:)), for: .valueChanged)
        picuRefresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        planRefresh.addTarget(self, action: #selector(planUpdateUI(refresh:)), for: .valueChanged)
        planRefresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        picuTableView.refreshControl = picuRefresh
        planTableView.refreshControl = planRefresh
    }
    
    @objc private func picuUpdateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        getPICU()
    }
    
    @objc private func planUpdateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        getPlan()
    }
    
    private func getPICU() {
        httpClient
            .get(url: CalendarAPI.getPICU(date).path(), params: nil, header: Header.token.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 200:
                    do {
                        print("OK - getPICU")
                        
                        let data = response.data
                        let model = try JSONDecoder().decode(picuContentResponses.self, from: data!)
                        
                        picu.picuContentResponses.removeAll()
                        
                        appendMetadata(num: 1)
                        
                        picu.picuContentResponses.append(contentsOf: model.picuContentResponses)
                        picuTableView.reloadData()
                    } catch {
                        print("Error: \(error)")
                    }
                    
                case 403:
                    print("403 : Forbidden - getPICU")
                    
                case 404:
                    print("404 : NOT FOUND - Notice does not exist. - getPICU")
                    
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
    
    private func createPICU(description: String, date: String) {
        httpClient
            .post(url: CalendarAPI.createPICU.path(), params: ["description": description, "date": date], header: Header.token.header())
            .responseJSON(completionHandler: {[unowned self](response) in
            switch response.response?.statusCode {
            case 201:
                print("OK - createPICU")
                dismiss(animated: true, completion: nil)
                
            case 400:
                showToast(message: "권한 없음")
                
            case 403:
                print("403 : Forbidden - createPICU")
                
            case 404:
                print("404 : NOT FOUND - Notice does not exist. - createPICU")
                
            default:
                print(response.response?.statusCode ?? "default")
                print(response.error ?? "default")
            }
        })
    }
    
    private func getPlan() {
        httpClient
            .get(url: CalendarAPI.getPlan(date).path(), params: nil, header: Header.token.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 200:
                    do {
                        print("OK - getPICU")
                        
                        let data = response.data
                        let model = try JSONDecoder().decode(planContentResponses.self, from: data!)
                        
                        plan.planContentResponses.removeAll()
                        
                        appendMetadata(num: 2)
                        
                        plan.planContentResponses.append(contentsOf: model.planContentResponses)
                        planTableView.reloadData()
                    } catch {
                        print("Error: \(error)")
                    }
                    
                case 403:
                    print("403 : Forbidden - getPICU")
                    
                case 404:
                    print("404 : NOT FOUND - Notice does not exist. - getPICU")
                    
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
    
    private func createPlan(title: String, description: String, date: String) {
        httpClient
            .post(url: CalendarAPI.createPlan.path(), params: ["description": description, "title": title, "date": date], header: Header.token.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 201:
                    print("OK - createPlan")
                    dismiss(animated: true, completion: nil)
                    
                case 400:
                    showToast(message: "권한 없음")
                    
                case 403:
                    print("403 : Forbidden - createPlan")
                    
                case 404:
                    print("404 : NOT FOUND - Notice does not exist. - createPlan")
                    
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
}
