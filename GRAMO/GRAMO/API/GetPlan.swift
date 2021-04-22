//
//  GetPlan.swift
//  GRAMO
//
//  Created by 정창용 on 2021/04/13.
//

import Foundation

struct GetPlan: Codable {
    var planId = Int()
    var title = String()
    var description = String()
    
    init (planId: Int, title: String, description: String) {
        self.planId = planId
        self.title = title
        self.description = description
        
    }
    
}

