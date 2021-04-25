//
//  Calendar2VC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
//

import UIKit
import FSCalendar

// MARK: Calendar2VC
class Calendar2VC: UIViewController {
    @IBOutlet var calendar: FSCalendar!
    
    private var getCalendarListModel: [GetCalendarList] = []
    
    private var events = [Date]()
    private let formatter = DateFormatter()
    
    private let httpClient = HTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCalendar()
        setUpEvents()
        
        overrideUserInterfaceStyle = .light
        
    }
    
}

extension Calendar2VC: FSCalendarDelegate, FSCalendarDataSource {
    // 이벤트 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
            
        } else {
            return 0
            
        }
        
    }
    
    // 숫자 글자로 바꾸기
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        switch formatter.string(from: date) {
        case "2021-09-03", "2022-09-03":
            return "Bir"
        
        default:
            return nil
        
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " 선택됨")
        
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        modalPresentView.date = dateFormatter.string(from: date)

        self.present(modalPresentView, animated: true, completion: nil)

    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            setUpEvents()
            
        }
        
    }
    
    func setUpCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 옆에 이상한거 제거
        calendar.appearance.headerDateFormat = "YYYY년 M월" // 헤더
        calendar.headerHeight = 85 // 헤더 크기
        calendar.locale = Locale(identifier: "ko_KR") // 요일 한글
        calendar.appearance.weekdayTextColor = .black // 요일 색
        calendar.appearance.headerTitleColor = .black // 헤더 색
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16)
        calendar.appearance.eventDefaultColor = .red // 이벤트 색
        // calendar.appearance.todaySelectionColor = .white // 오늘 선택 색
        calendar.appearance.titleWeekendColor = .red // 주말 색
        
        // 스와이프 스크롤 방향 ( 버티칼로 스와이프 설정하면 좌측 우측 상단 다음달 표시 없어짐, 호리젠탈은 보임 )
        calendar.scrollDirection = .vertical
        
    }
    
    func setUpEvents() {
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let current_date_string = formatter.string(from: Date())
        
        getCalendarList(date: current_date_string)
                
    }
    
    func getCalendarList(date: String) {
        httpClient.get(.getCalendarList(date)).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                do {
                    print("OK - Send notice list successfully. - getCalendarList")
                    print(date)
                    
                    let data = response.data
                    let model = try JSONDecoder().decode([GetCalendarList].self, from: data!)
                    var num: Int = 0
                    
                    self.getCalendarListModel = model
                    
                    for _ in self.getCalendarListModel {
                        if self.getCalendarListModel[num].picuCount != 0 || self.getCalendarListModel[num].planCount != 0 {
                            let event = self.formatter.date(from: self.getCalendarListModel[num].date)
                            
                            self.events.append(event!)
                            
                        }
                        
                        num += 1
                        
                    }
                    
                    self.calendar.reloadData()
                    
                } catch {
                    print("Error: \(error)")
                    
                }
                
            case 403:
                print("403 : Token Token Token Token - getCalendarList")
                
            case 404:
                print("404 : NOT FOUND - Notice does not exist. - getCalendarList")
                
            default:
                print(response.response?.statusCode)
                print(response.error)
            
            }
            
        })

    }
    
}

