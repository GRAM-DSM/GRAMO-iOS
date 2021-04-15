//
//  PICUCellModel.swift
//  GRAMO
//
//  Created by 정창용 on 2021/04/08.
//

import Foundation

struct PICUCellModel: Codable {
    var name = String()
    var detail = String()
    
    init (name: String, detail: String) {
        self.name = name
        self.detail = detail
        
    }
    
}

