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
            return baseURIHomework + "/homework/assign"
            
        case .getSubHomeworkList:
            return baseURIHomework + "/homework/submit"
            
        case .getOrdHomeworkList:
            return baseURIHomework + "/homework/order"
            
        case .getHomeworkContent(let homeworkId):
            return baseURIHomework + "/homework/\(homeworkId)"
            
        case .createHomework:
            return baseURIHomework + "/homework"
            
        case .deleteHomework(let detailId):
            return baseURIHomework + "/homework/\(detailId)"
            
        case .submitHomework(let homeworkId):
            return baseURIHomework + "/homework/\(homeworkId)"
            
        case .rejectHomework(let homeworkId):
            return baseURIHomework + "/homework/reject/\(homeworkId)"
            
        case .getUserList:
            return baseURIHomework + "/user/list"
        }
    }
}
