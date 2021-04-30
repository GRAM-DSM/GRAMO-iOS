//
//  SecondSectionModel.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/15.
//

import Foundation

struct SecondSection {
    var recipient2 = String()
    var date2 = String()
    var title2 = String()
    var detail2 = String()
    
    init(recipient2: String, date2: String,
         title2: String, detail2: String){
        self.recipient2 = recipient2
        self.date2 = date2
        self.title2 = title2
        self.detail2 = detail2
    }
}
