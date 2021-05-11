//
//  HwUser.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct UserList: Codable {
    var email = String()
    var name = String()
    var major = String()
    
    init(email: String, name: String, major: String) {
        self.email = email
        self.name = name
        self.major = major
    }
}
