//
//  Calendar2VC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
//

import UIKit
import FSCalendar

class Calendar2VC: UIViewController {
    @IBOutlet var calendar: FSCalendar!
    
    let formatter = DateFormatter()
    var events = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.allowsMultipleSelection = true
        
        customCalendar()
        
        setUpEvents()
        
    }
    
    func customCalendar() {
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 옆에 이상한거 제거
        calendar.appearance.headerDateFormat = "M월" // 헤더
        calendar.headerHeight = 85 // 헤더 크기
        calendar.locale = Locale(identifier: "ko_KR") // 요일 한글
        calendar.appearance.weekdayTextColor = .black // 요일 색
        calendar.appearance.headerTitleColor = .black // 헤더 색
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16)
        calendar.appearance.eventDefaultColor = .red // 이벤트 색
        calendar.appearance.todaySelectionColor = .white // 오늘 선택 색
        
        
        // 스와이프 스크롤 방향 ( 버티칼로 스와이프 설정하면 좌측 우측 상단 다음달 표시 없어짐, 호리젠탈은 보임 )
        calendar.scrollDirection = .vertical
        
    }
    
    func setUpEvents() {
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let xmas = formatter.date(from: "2021-12-25")
        let sampledate = formatter.date(from: "2021-08-22")
        let today = formatter.date(from: "2021-03-22")
        
        events = [xmas!, sampledate!, today!]
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " 선택됨")
        
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
    
}

