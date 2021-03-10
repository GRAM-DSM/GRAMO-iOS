//
//  FirstSectionModel.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/15.
//

import Foundation

struct FirstSection {
    var myName1 = String()
    var date1 = String()
    var title1 = String()
    var detail1 = String()
    
    init(myName1: String, date1: String,
         title1: String, detail1: String){
        self.myName1 = myName1
        self.date1 = date1
        self.title1 = title1
        self.detail1 = detail1
    }
}
