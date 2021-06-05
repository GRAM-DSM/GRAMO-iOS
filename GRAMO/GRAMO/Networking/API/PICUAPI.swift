//
//  PICUAPI.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/04.
//

import Foundation

enum PICUAPI : API {
    case getCalendarList(_ date: String)
    case getPICU(_ date: String)
    case getPlan(_ date: String)
    case createPICU(_ description: String, _ date: String)
    case createPlan(_ description: String, _ title: String, _ date: String)
    case deletePICU(_ picuId: Int)
    case deletePlan(_ planId: Int)
    
    func path() -> String {
        switch self {
        case .getCalendarList(let date):
            return "calendar/\(date)"
            
        case .getPICU(let date):
            return "calendar/picu/\(date)"
            
        case .createPICU:
            return "calendar/picu"
            
        case .deletePICU(let picuId):
            return "calendar/picu/\(picuId)"
                    
        case .getPlan(let date):
            return "calendar/plan/\(date)"
            
        case .createPlan:
            return "calendar/plan"
            
        case .deletePlan(let picuId):
            return "calendar/plan/\(picuId)"
        }
    }
}
