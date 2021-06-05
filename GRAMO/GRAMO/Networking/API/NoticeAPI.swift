//
//  NoticeAPI.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/04.
//

import Foundation

enum NoticeAPI: API {
    case getNoticeList(_ off_set : Int, _ limit_num : Int)
    case getNoticeDetail(_ id: Int)
    case createNotice(_ title: String, _ content: String)
    case deleteNotice(_ id: Int)
    
    func path() -> String {
        switch self {
        case .getNoticeList(let off_set, let limit_num):
            return baseURINotice + "/notice/\(off_set)/\(limit_num)"
            
        case .createNotice:
            return baseURINotice + "/notice"
            
        case .getNoticeDetail(let id), .deleteNotice(let id):
            return baseURINotice + "/notice/\(id)"
        }
    }
}
