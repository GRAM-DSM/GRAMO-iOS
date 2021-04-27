//
//  HwContent.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct HwContent: Codable {
    var homeworkId = Int()
    var title = String()
    var description = String()
    var startDate = String()
    var endDate = String()
    var isRejected = Bool()
    var major = String()
    var teacherName = String()
    var studentName = String()
    var isMine = Bool()
    
    init(homeworkId: Int, title: String, description: String, startDate: String, endDate: String,
         isRejected: Bool, major: String, teacherName: String, studentName: String, isMine: Bool) {
        self.homeworkId = homeworkId
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.isRejected = isRejected
        self.major = major
        self.teacherName = teacherName
        self.isMine = isMine
    }
}
