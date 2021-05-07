//
//  Networking.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

public enum NetworkingAPI {
    case signIn(_ email : String, _ password : String)
    case logout
    case tokenRefresh
    case withDrawel
    case signUp(_ name : String, _ email : String, _ password : String, _ major : String)
    case sendEmail(_ email : String)
    case checkEmailCode(_ code : String)
    
    var path : String {
        switch self {
        case .signIn, .tokenRefresh, .logout:
            return "/auth"
            
        case .withDrawel:
            return "/withdrawel"
            
        case .signUp:
            return "/signup"
            
        case .sendEmail:
            return "/sendemail"
            
        case .checkEmailCode:
            return "/checkcode"
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .tokenRefresh:
            let refreshToken : String = "token"
            let UserDefault = UserDefaults.standard
            UserDefault.set(refreshToken, forKey: "refreshToken")
            UserDefault.synchronize()
            guard  let token = UserDefault.string(forKey: "refreshToken") else { return nil }
            return ["Authorization" : "Bearer" + token]
            
        default:
            let justToken: String = "token"
            let UserDefault = UserDefaults.standard
                    
            UserDefault.set(justToken, forKey: "justToken")
            UserDefault.synchronize()
                    
            guard let token = UserDefault.string(forKey: "justToken") else { return nil }
                    
            // return ["Authorization" : "Bearer" + token]
            return ["Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYxOTUxMDA1MCwianRpIjoiNTk2YzkwMmYtNDIwNC00ZWZkLWI0ZGMtYjI0YmVkY2IyMWIxIiwibmJmIjoxNjE5NTEwMDUwLCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoiY2hhbmd4QGdtYWlsLmNvbSIsImV4cCI6MTYxOTU5NjQ1MH0.WHcfLQ06j8953edGLColVALvLmbr__eNDzYLYhzfLVs"]
        }
    }
    
    var parameters: [String : Any]{
        switch self {
        case .signIn(let email, let password):
            print(["email": email, "password": password])
            return ["email": email, "password": password]
            
        case .signUp(let name, let email, let password, let major):
            print(["name": name, "email": email, "password": password, "major" : major])
            return ["name": name, "email" : email, "password" : password, "major" : major]
            
        case .checkEmailCode(let code):
            print(["code": code])
            return ["code": code]
            
        case .sendEmail(let email):
            print(["email": email])
            return ["email": email]
            
        default:
            return [:]
        }
    }
}
