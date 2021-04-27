//
//  Networking.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

let baseURINotice = "http://13.209.8.210:5000/"
let baseURIHw = "http://211.38.86.92:8001"


enum NetworkingAPI {
    case getNoticeList(_ off_set : Int, _ limit_num : Int)
    case getNoticeDetail(_ id: Int)
    case createNotice(_ title: String, _ content: String)
    case deleteNotice(_ id: Int)
    
    case getAssHwList
    case getSubHwList
    case getOrdHwList
    
    case getHwContent(_ homeworkId: Int)
    case createHw(_ major: String, _ endDate: String, _ studentEmail: String, _ description: String, _ title: String)
    case deleteHw(_ detailId: Int)
    
    case submitHw(_ homeworkId: Int)
    case rejectHw(_ homeworkId: Int)
    
    case getUserList
    
    
    var path: String {
        switch self {
        case .getNoticeList(let off_set, let limit_num):
            return baseURINotice + "/notice/\(off_set)/\(limit_num)"
        case .createNotice:
            return baseURINotice + "/notice"
        case .getNoticeDetail(let id), .deleteNotice(let id):
            return baseURINotice + "/notice/\(id)"
        case .getAssHwList:
            return baseURIHw + "/homework/assign"
        case .getSubHwList:
            return baseURIHw + "/homework/submit"
        case .getOrdHwList:
            return baseURIHw + "/homework/order"
        case .getHwContent(let homeworkId):
            return baseURIHw + "/homework/\(homeworkId)"
        case .createHw:
            return baseURIHw + "/homework"
        case .deleteHw(let detailId):
            return baseURIHw + "/homework/\(detailId)"
        case .submitHw(let homeworkId):
            return baseURIHw + "/homework/\(homeworkId)"
        case .rejectHw(let homeworkId):
            return baseURIHw + "/homework/reject/\(homeworkId)"
        case .getUserList:
            return baseURIHw + "/user/list"
            
        }
    }
    
    var header: HTTPHeaders? {
        switch self {
        default:
            return ["Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYxOTUxMDA1MCwianRpIjoiNTk2YzkwMmYtNDIwNC00ZWZkLWI0ZGMtYjI0YmVkY2IyMWIxIiwibmJmIjoxNjE5NTEwMDUwLCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoiY2hhbmd4QGdtYWlsLmNvbSIsImV4cCI6MTYxOTU5NjQ1MH0.WHcfLQ06j8953edGLColVALvLmbr__eNDzYLYhzfLVs"]
        }
        
        //        let accessToken : String = "access_token"
        //                    let userDefault = UserDefaults.standard
        //                    userDefault.set(accessToken, forKey: "access_token")
        //                    userDefault.synchronize( )
        //                    guard let token = userDefault.string(forKey: "access_token") else { return nil }
        //                    return ["Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYxODMwMDMxMCwianRpIjoiMzFmZmY0MjItYzQ4OS00ZDk1LWEwN2QtYjBlMmUxZTc4ODEwIiwibmJmIjoxNjE4MzAwMzEwLCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoidGVzdGlvc0BnbWFpbC5jb20iLCJleHAiOjE2MTgzODY3MTB9.8mcy-vd7vCAVL39a0fOrx5ax4F1CAX7JfZGr5OyDxEU"]
    }
    
    var parameter: [String:Any] {
        switch self {
        //        case .getNoticeList(let off_set, let limit_num):
        
        case .getNoticeDetail(let id):
            return ["id":id]
        case .createNotice(let title, let content):
            return ["title":title, "content":content]
        case .getHwContent(let homeworkId):
            return ["homeworkId":homeworkId]
        case .createHw(let major, let endDate, let studentEmail, let description, let title):
            return ["major":major, "endDate":endDate, "studentEmail":studentEmail, "description":description, "title":title]
        case .deleteHw(let deleteId):
            return ["deleteId":deleteId]
        case .submitHw(let homeworkId):
            return ["homeworkId":homeworkId]
        case .rejectHw(let homeworkId):
            return ["homeworkId":homeworkId]
        default : return [:]
        }
    }
}
