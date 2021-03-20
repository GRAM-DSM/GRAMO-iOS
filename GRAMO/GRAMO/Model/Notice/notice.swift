//
//  notice.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct Notice: Codable {
    var id = Int()
    var title = String()
    var content = String()
    var user_email = String()
    var created_at = String()
    
    init(id: Int, title: String, content: String, user_email: String, created_at: String) {
        self.id = id
        self.title = title
        self.content = content
        self.user_email = user_email
        self.created_at = created_at
    }
}
