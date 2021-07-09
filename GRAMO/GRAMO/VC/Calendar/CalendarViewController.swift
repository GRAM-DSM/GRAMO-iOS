//
//  Calendar2VC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {
    @IBOutlet private weak var calendar: FSCalendar!
    
    private var events = [Date]()
    private let formatter = DateFormatter()
    
    private let httpClient = HTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customCalendar()
        customEvents()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " 선택됨")
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        
        modalPresentView.date = formatter.string(from: date)
        self.present(modalPresentView, animated: true, completion: nil)
    }
    
    private func customCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.allowsMultipleSelection = false
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.headerHeight = 85
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16)
        calendar.appearance.eventDefaultColor = .red
        calendar.appearance.titleWeekendColor = .red
        calendar.scrollDirection = .vertical
    }
    
    private func customEvents() {
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM"
        let current_date_string = formatter.string(from: Date())
        
        getCalendarList(date: current_date_string)
        print(current_date_string)
    }
    
    private func getCalendarList(date: String) {
        httpClient
            .get(url: CalendarAPI.getCalendarList(date).path(), params: nil, header: Header.token.header())
            .responseJSON(completionHandler: {[unowned self](response) in
                switch response.response?.statusCode {
                case 200:
                    do {
                        print("OK - getCalendarList")
                        print(date)
                        
                        let data = response.data
                        let model = try JSONDecoder().decode(calendarContentResponses.self, from: data!)
                        
                        events.removeAll()
                        
                        for i in model.calendarContentResponses {
                            if i.picuCount != 0 || i.planCount != 0 {
                                formatter.dateFormat = "yyyy-MM-dd"
                                events.append(self.formatter.date(from: i.date)!)
                            }
                        }
                        
                        calendar.reloadData()
                    } catch {
                        print("Error: \(error)")
                    }
                    
                case 403:
                    print("403 : Forbidden - getCalendarList")
                    
                case 404:
                    print("404 : NOT FOUND - Notice does not exist. - getCalendarList")
                    
                default:
                    print(response.response?.statusCode ?? "default")
                    print(response.error ?? "default")
                }
            })
    }
}
