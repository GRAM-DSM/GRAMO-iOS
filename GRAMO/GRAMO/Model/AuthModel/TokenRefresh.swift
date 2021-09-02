//
//  tokenRefresh.swift
//  GRAMO
//
//  Created by 정창용 on 2021/09/02.
//

import Foundation

struct TokenRefresh: Codable {
    var access_token = String()
    
    init (access_token: String) {
        self.access_token = access_token
    }
}
