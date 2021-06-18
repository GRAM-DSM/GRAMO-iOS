//
//  NoticeAPI.swift
//  GRAMO
//
//  Created by 정창용 on 2021/06/04.
//

import Foundation

enum NoticeAPI: API {
    case getNoticeList(_ page : Int)
    case getNoticeDetail(_ id: Int)
    case createNotice
    case deleteNotice(_ id: Int)
    
    func path() -> String {
        switch self {
        case .getNoticeList(let page):
            return baseURIAuth + "/notice/list/\(page)"
            
        case .createNotice:
            return baseURIAuth + "/notice"
            
        case .getNoticeDetail(let id), .deleteNotice(let id):
            return baseURIAuth + "/notice/\(id)"
        }
    }
}
