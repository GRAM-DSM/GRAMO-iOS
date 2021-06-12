//
//  PICUAPI.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/04.
//

import Foundation

enum CalendarAPI : API {
    case getCalendarList(_ date: String)
    case getPICU(_ date: String)
    case getPlan(_ date: String)
    case createPICU
    case createPlan
    case deletePICU(_ picuId: Int)
    case deletePlan(_ planId: Int)
    
    func path() -> String {
        switch self {
        case .getCalendarList(let date):
            return baseURICalendar + "/calendar/\(date)"
            
        case .getPICU(let date):
            return baseURICalendar + "/calendar/picu/\(date)"
            
        case .createPICU:
            return baseURICalendar + "/calendar/picu"
            
        case .deletePICU(let picuId):
            return baseURICalendar + "/calendar/picu/\(picuId)"
                    
        case .getPlan(let date):
            return baseURICalendar + "/calendar/plan/\(date)"
            
        case .createPlan:
            return baseURICalendar + "/calendar/plan"
            
        case .deletePlan(let planId):
            return baseURICalendar + "/calendar/plan/\(planId)"
        }
    }
}
