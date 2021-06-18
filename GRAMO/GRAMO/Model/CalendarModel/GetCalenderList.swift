//
//  GetCalenderList.swift
//  GRAMO
//
//  Created by 정창용 on 2021/04/13.
//

import Foundation

struct calendarContentResponses: Codable {
    var calendarContentResponses = [GetCalendarList]()
}

struct GetCalendarList: Codable {
    var id = Int()
    var date = String()
    var picuCount = Int()
    var planCount = Int()
    
    init (id: Int, date: String, picuCount: Int, planCount: Int) {
        self.id = id
        self.date = date
        self.picuCount = picuCount
        self.planCount = planCount
    }
}
