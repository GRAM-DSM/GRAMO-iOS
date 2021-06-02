//
//  infoListModel.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/04.
//

import Foundation

struct InfoList: Codable {
    var writer = String()
    var date = String()
    var infotTitle = String()
    var infoDetail = String()
    
    init(writer: String, date: String,
         infotTitle: String, infoDetail: String){
        self.writer = writer
        self.date = date
        self.infotTitle = infotTitle
        self.infoDetail = infoDetail
    }
}
