//
//  AuthAPI.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/04.
//

import Foundation

enum AuthAPI: API {
    case signIn
    case logout
    case tokenRefresh
    case withDrawal
    case signUp
    case sendEmail
    case checkEmailCode

    func path() -> String {
        switch self {
        case .signIn, .tokenRefresh, .logout:
            return baseURIAuth + "/auth"
        
        case .withDrawal:
            return baseURIAuth + "/withdrawal"
        
        case .signUp:
            return baseURIAuth + "/signup"
        
        case .sendEmail:
            return baseURIAuth + "/sendemail"
        
        case .checkEmailCode:
            return baseURIAuth + "/checkcode"
        }
    }
}
