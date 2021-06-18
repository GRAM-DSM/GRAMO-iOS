//
//  Calendar2VC.swift
//  GRAMO
//
//  Created by 정창용 on 2021/03/10.
//

import UIKit
import FSCalendar

class Calendar2VC: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    
    private var events = [Date]()
    private let formatter = DateFormatter()
    
    private let httpClient = HTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCalendar()
        setUpEvents()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            setUpEvents()
        }
    }
}

// MARK: Calendar
extension Calendar2VC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
<<<<<<< Updated upstream
    // 숫자 글자로 바꾸기
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        switch formatter.string(from: date) {
        case "2021-09-03", "2022-09-03":
            return "Bir"
            
        default:
            return nil
        }
    }
    
=======
>>>>>>> Stashed changes
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " 선택됨")
        
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
<<<<<<< Updated upstream
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        modalPresentView.date = dateFormatter.string(from: date)
        
=======

        formatter.dateFormat = "yyyy-MM-dd"
        modalPresentView.date = formatter.string(from: date)

>>>>>>> Stashed changes
        self.present(modalPresentView, animated: true, completion: nil)
    }
    
    func setUpCalendar() {
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
    
    func setUpEvents() {
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM"
        let current_date_string = formatter.string(from: Date())
        
        getCalendarList(date: current_date_string)
        print(current_date_string)
    }
    
    func getCalendarList(date: String) {
        httpClient.get(url: CalendarAPI.getCalendarList(date).path(), params: nil, header: Header.token.header()).responseJSON(completionHandler: {(response) in
            switch response.response?.statusCode {
            case 200:
                do {
                    print("OK - Send notice list successfully. - getCalendarList")
                    print(date)
                    
                    let data = response.data
                    let model = try JSONDecoder().decode(calendarContentResponses.self, from: data!)
                    
                    self.events.removeAll()
                    
                    for i in model.calendarContentResponses {
                        if i.picuCount != 0 || i.planCount != 0 {
                            self.formatter.dateFormat = "yyyy-MM-dd"
                            self.events.append(self.formatter.date(from: i.date)!)
                        }
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
                print(response.response?.statusCode ?? "default")
                print(response.error ?? "default")
            }
        })
    }
}
