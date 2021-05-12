//
//  GetCalenderList.swift
//  GRAMO
//
//  Created by 정창용 on 2021/04/13.
//

import Foundation

struct GetCalendarList: Codable {
    var date = String()
    var picuCount = Int()
    var planCount = Int()
    
    init (date: String, picuCount: Int, planCount: Int) {
        self.date = date
        self.picuCount = picuCount
        self.planCount = planCount
    }
}
