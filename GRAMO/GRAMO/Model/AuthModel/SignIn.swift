//
//  SignIn.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/10.
//

import Foundation

struct SignIn: Codable {
    var name = String()
    var major = String()
    var access_token = String()
    var refresh_token = String()
    
    init (name: String, major: String, access_token: String, refresh_token: String) {
        self.name = name
        self.major = major
        self.access_token = access_token
        self.refresh_token = refresh_token
    }
}

struct Model{
    static var name = String()
    static var major = String()
}
