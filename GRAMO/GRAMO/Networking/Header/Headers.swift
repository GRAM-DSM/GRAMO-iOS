//
//  Headers.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/04.
//

import Foundation
import Alamofire

struct Token {
    static var _accessToken: String?
    static var accessToken: String? {
        get {
            _accessToken = UserDefaults.standard.string(forKey: "accessToken")
            return _accessToken
        } set(newAccessToken) {
            UserDefaults.standard.setValue(newAccessToken, forKey: "accessToken")
            _accessToken = UserDefaults.standard.string(forKey: "accessToken")
        }
    }
    
    static var _refreshToken: String?
    static var refreshToken: String? {
        get {
            _refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
            return _refreshToken
        } set(newRefreshToken) {
            UserDefaults.standard.setValue(newRefreshToken, forKey: "refreshToken")
            _refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        }
    }
    
    static func remove() {
            accessToken = nil
        }
}

enum Header {
    case accessToken, refreshToken, tokenIsEmpty
    
    func header() -> HTTPHeaders {
        guard let accessToken = Token.accessToken else {
            return ["Content-Type" : "application/json"]
        }
        
        guard let refreshToken = Token.refreshToken else {
            return ["Content-Type" : "application/json"]
        }
        
        switch self {
        case .accessToken:
            return HTTPHeaders(["Authorization" : "Bearer " + accessToken, "Content-Type" : "application/json"])
            
        case .refreshToken:
            return HTTPHeaders(["Authorization" : "Bearer " + refreshToken, "Content-Type" : "application/json"])
            
        case .tokenIsEmpty:
            return ["Content-Type" : "application/json"]
        }
    }
}
