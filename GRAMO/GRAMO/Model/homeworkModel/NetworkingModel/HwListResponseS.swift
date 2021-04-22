//
//  HwListResponseS.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct HwStudent: Codable {
    var homeworkId = Int()
    var studentName = String()
    var teacherName = String()
    var title = String()
    var description = String()
    var major = String()
    var startDate = String()
    var endDate = String()
    var isRejected = Bool()
    
    init(homeworkId: Int, studentName: String, teacherName: String, startDate: String, endDate: String,
         title: String, isRejected: Bool, major: String, description: String) {
        self.homeworkId = homeworkId
        self.studentName = studentName
        self.teacherName = teacherName
        self.title = title
        self.description = description
        self.major = major
        self.startDate = startDate
        self.endDate = endDate
        self.isRejected = isRejected
        
        
    }
}
