//
//  noticeDetail.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct noticeDetail: Codable {
    var name = String()
    var created_at = String()
    var title = String()
    var content = String()
    
    init(name: String, created_at: String, title: String, content: String){
        self.name = name
        self.created_at = created_at
        self.title = title
        self.content = content
    }
}
