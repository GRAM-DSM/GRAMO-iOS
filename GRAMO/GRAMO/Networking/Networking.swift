//
//  Networking.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

public enum NetworkingAPI{
    case Login(_ email : String, _ password : String)
    case refreshToken
    case SignUp(_ name : String, _ email : String, _ password : String, _ major : String)
    case SendEmail(_ email : String)
    case CheckEmailAuthenticationCode(_ code : String)
    
    var path : String {
        switch self {
        case .Login, .refreshToken :
            return "auth"
            
        case .SignUp, .SendEmail, .CheckEmailAuthenticationCode :
            return "email"
            
        }
        
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .Login, .SignUp, .SendEmail, .CheckEmailAuthenticationCode:
            return nil
            
        case .refreshToken:
            let refreshToken : String = "token"
            let UserDefault = UserDefaults.standard
            UserDefault.set(refreshToken, forKey: "refreshToken")
            UserDefault.synchronize()
            guard  let token = UserDefault.string(forKey: "refreshToken") else { return nil }
            return ["Authorization" : "Bearer" + token]
            
        default:
            let defaultToken : String = "accessToken"
            let UserDefault = UserDefaults.standard
            UserDefault.set(defaultToken, forKey: "accessToken")
            UserDefault.synchronize()
            guard let token = UserDefault.string(forKey: "accessToken") else { return nil }
            let headers = [
                "Authorization" : String (format : "Bearer : @%", token
                
                )
                
            ]
            
        return ["Authorization" : "Bearer" + token]
            
        }
        
    }
    
    var parameters: [String : Any]{
        switch self {
        case .Login(let email, let password):
            print(["email": email, "password": password])
            return ["email": email, "password": password]
            
        case .SignUp(let name, let email, let password, let major):
            print(["name": name, "email": email, "password": password, "major" : major])
            return ["name": name, "email" : email, "password" : password, "major" : major]
            
        case .CheckEmailAuthenticationCode(let code):
            print(["code": code])
            return ["code": code]
            
        case .SendEmail(let email):
            print(["email": email])
            return ["email": email]
            
        default:
            return [:]
            
        }
        
    }
        
}

