//
//  HwContent.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct HwContent: Codable {
    var title = String()
    var description = String()
    var startDate = String()
    var endDate = String()
    var isSubmitted = String()
    var isMine = String()
    var major = String()
    var teacherName = String()
    
    init(title: String, description: String, startDate: String, endDate: String,
         isSubmitted: String, isMine: String, major: String, teacherName: String) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.isSubmitted = isSubmitted
        self.isMine = isMine
        self.major = major
        self.teacherName = teacherName
    }
}
