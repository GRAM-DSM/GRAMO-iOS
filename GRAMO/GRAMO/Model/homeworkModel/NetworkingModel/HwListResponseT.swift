//
//  HomeworkListResponse.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct Hwteacher: Codable {
    var homeworkId = Int()
    var teacherName = String()
    var startDate = String()
    var endDate = String()
    var title = String()
    var isRejected = String()
    var major = String()
    var description = String()
    
    init(homeworkId: Int, teacherName: String, startDate: String, endDate: String,
         title: String, isRejected:String, major: String, description: String) {
        self.homeworkId = homeworkId
        self.teacherName = teacherName
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.isRejected = isRejected
        self.major = major
        self.description = description
    }
}
