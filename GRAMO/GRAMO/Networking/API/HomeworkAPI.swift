//
//  HomeworkAPI.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/04.
//

import Foundation

enum HomeworkAPI: API {
    case getAssHomeworkList
    case getSubHomeworkList
    case getOrdHomeworkList
    
    case getHomeworkContent(_ homeworkId: Int)
    case createHomework
    case deleteHomework(_ detailId: Int)
    
    case submitHomework(_ homeworkId: Int)
    case rejectHomework(_ homeworkId: Int)
    
    case getUserList
    
    func path() -> String {
        switch self {
        case .getAssHomeworkList:
            return baseURICalendar + "/homework/assign"
            
        case .getSubHomeworkList:
            return baseURICalendar + "/homework/submit"
            
        case .getOrdHomeworkList:
            return baseURICalendar + "/homework/order"
            
        case .getHomeworkContent(let homeworkId):
            return baseURICalendar + "/homework/\(homeworkId)"
            
        case .createHomework:
            return baseURICalendar + "/homework"
            
        case .deleteHomework(let detailId):
            return baseURICalendar + "/homework/\(detailId)"
            
        case .submitHomework(let homeworkId):
            return baseURICalendar + "/homework/\(homeworkId)"
            
        case .rejectHomework(let homeworkId):
            return baseURICalendar + "/homework/reject/\(homeworkId)"
            
        case .getUserList:
            return baseURICalendar + "/user/list"
        }
    }
}
