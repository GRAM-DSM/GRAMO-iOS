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
    case getPICU(_ date: String)
    case getPlan(_ date: String)
    case createPICU(_ description: String, _ date: String)
    case createPlan(_ description: String, _ title: String, _ date: String)
    case deletePICU(_ picuId: Int)
    case deletePlan(_ planId: Int)
    
    var path: String {
        switch self {
        case .getCalendarList(let date):
            print("path에서 \(date)")
            return "calendar?date=\(date)"
            
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
    
    var headers: HTTPHeaders? {
        let justToken: String = "token"
        let UserDefault = UserDefaults.standard
        
        UserDefault.set(justToken, forKey: "justToken")
        UserDefault.synchronize()
        
        guard let token = UserDefault.string(forKey: "justToken") else { return nil }
        
        // return ["Authorization" : "Bearer" + token]
        return [ "Content-Type" : "application/json", "Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYxOTI3NDA3MCwianRpIjoiMjcyZTdiM2MtYzA1Ny00MTFhLWExODItZTA5MmQ5MmY1Y2JjIiwibmJmIjoxNjE5Mjc0MDcwLCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoiY2tkZHlkMTIwMkBkYXVtLm5ldCIsImV4cCI6MTYxOTM2MDQ3MH0.Zetexxxq4-pQVXXPECqiLwXM_xRSbrVhnXk1nLQliLQ"]
        
    }
    
    var parameters: [String: Any] {
        switch self {
        case .createPICU(let description, let date):
            print(["description": description, "date": date])
            return ["description": description, "date": date]
            
        case .createPlan(let description, let title, let date):
            print(["description": description, "title": title, "date": date])
            return ["description": description, "title": title, "date": date]
            
        default:
            return [:]
            
        }
    
    }
    
}

