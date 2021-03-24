//
//  Networking.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

public enum NetworkingAPI{
    case getCalendarList
    case getPlan(_ date : String)
    case createPlan(_ content : String, _ title: String, _ date: String)
    case deletePlan(_ planId : String)
    case getPICU(_ date : String)
    case createPICU(_ description : String, _ date : String)
    case deletePICU(_ picuId : String)
    
    var path : String {
        switch self {
        case .getCalendarList :
            return "calendar"
                    
        case .getPlan, .createPlan, .deletePlan :
            return "calendar/plan"
            
        case .getPICU, .createPICU, .deletePICU :
            return "calendar/picu"
            
        }
        
    }
    
    var headers: HTTPHeaders? {
        let justToken: String = "token"
        let UserDefault = UserDefaults.standard
        
        UserDefault.set(justToken, forKey: "justToken")
        UserDefault.synchronize()
        
        guard let token = UserDefault.string(forKey: "justToken") else { return nil }
        
        return ["Authorization" : "Bearer" + token]
        
    }
    
    var parameters: [String : Any]{
        switch self {
        case .getPlan(let date):
            print(["date": date])
            return ["date": date]
            
        case .createPlan(let content, let title, let date):
            print(["content": content, "title": title, "date": date])
            return ["content": content, "title": title, "date": date]
        
        case .deletePlan(let planId):
            print(["planId": planId])
            return ["planId": planId]
            
        case .getPICU(let date):
            print(["date": date])
            return ["date": date]
            
        case .createPICU(let description, let date):
            print(["description": description, "date": date])
            return ["description": description, "date": date]
            
        case .deletePICU(let picuId):
            print(["picuId": picuId])
            return ["picuId": picuId]
            
        default:
            return [:]
            
        }
        
    }
        
}

