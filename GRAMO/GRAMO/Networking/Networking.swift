//
//  Networking.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

public enum NetworkingAPI{
    case getCalendarList(_ date: String)
    case getPlan(_ date: String)
    case createPlan(_ content: String, _ title: String, _ date: String)
    case deletePlan(_ planId: String)
    case getPICU(_ date: String)
    case createPICU(_ description: String, _ date: String)
    case deletePICU(_ picuId: String)
    
    var path: String {
        switch self {
        case .getCalendarList(let date):
            print("path에서 \(date)")
            return "calendar?date=\(date)"
                    
        case .getPlan(let date):
            return "calendar/plan/\(date)"
            
        case .createPlan, .deletePlan:
            return "calendar/plan"
            
        case .getPICU(let date):
            return "calendar/picu/\(date)"
            
        case .createPICU, .deletePICU:
            return "calendar/picu"
            
        }
        
    }
    
    var headers: HTTPHeaders? {
        let justToken: String = "token"
        let UserDefault = UserDefaults.standard
        
        UserDefault.set(justToken, forKey: "justToken")
        UserDefault.synchronize()
        
        guard let token = UserDefault.string(forKey: "justToken") else { return nil }
        
        // return ["Authorization" : "Bearer" + token]
        return ["Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYxOTAxMTkzNywianRpIjoiYWRhNTgzMDYtOTk2MS00YzA0LTk3N2UtN2MzOWY5YjYwZWNmIiwibmJmIjoxNjE5MDExOTM3LCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoiY2tkZHlkMTIwMkBkYXVtLm5ldCIsImV4cCI6MTYxOTA5ODMzN30.UeO0IWElVbu9BmFW5KeA6Wt72juT_9EdGZX_9TlzeAM"]
        
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getCalendarList(let date):
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

