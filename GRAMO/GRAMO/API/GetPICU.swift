//
//  GetPICU.swift
//  GRAMO
//
//  Created by 정창용 on 2021/04/14.
//

import Foundation

struct PICUListResponse: Codable {
    var getPICU = [GetPICU]()
    
}

struct GetPICU: Codable {
    var picuId = Int()
    var userName = String()
    var description = String()
    
    init (picuId: Int, userName: String, description: String) {
        self.picuId = picuId
        self.userName = userName
        self.description = description
        
    }
    
}

