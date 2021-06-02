//
//  GetNoticeList.swift
//  GRAMO
//
//  Created by 장서영 on 2021/03/19.
//

import Foundation

struct GetNoticeList: Codable {
    var notice : [Notice] = [Notice]()
    var next_page = Bool()
}

