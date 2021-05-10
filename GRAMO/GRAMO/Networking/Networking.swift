//
//  Networking.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

let baseURINotice = "http://13.209.8.210:5000/"
let baseURIHomework = "http://211.38.86.92:8001"


enum NetworkingAPI {
    case getNoticeList(_ off_set : Int, _ limit_num : Int)
    case getNoticeDetail(_ id: Int)
    case createNotice(_ title: String, _ content: String)
    case deleteNotice(_ id: Int)
    
    case getAssHomeworkList
    case getSubHomeworkList
    case getOrdHomeworkList
    
    case getHomeworkContent(_ homeworkId: Int)
    case createHomework(_ major: String, _ endDate: String, _ studentEmail: String, _ description: String, _ title: String)
    case deleteHomework(_ detailId: Int)
    
    case submitHomework(_ homeworkId: Int)
    case rejectHomework(_ homeworkId: Int)
    
    case getUserList
    
    
    var path: String {
        switch self {
        case .getNoticeList(let off_set, let limit_num):
            return baseURINotice + "/notice/\(off_set)/\(limit_num)"
        case .createNotice:
            return baseURINotice + "/notice"
        case .getNoticeDetail(let id), .deleteNotice(let id):
            return baseURINotice + "/notice/\(id)"
        case .getAssHomeworkList:
            return baseURIHomework + "/homework/assign"
        case .getSubHomeworkList:
            return baseURIHomework + "/homework/submit"
        case .getOrdHomeworkList:
            return baseURIHomework + "/homework/order"
        case .getHomeworkContent(let homeworkId):
            return baseURIHomework + "/homework/\(homeworkId)"
        case .createHomework:
            return baseURIHomework + "/homework"
        case .deleteHomework(let detailId):
            return baseURIHomework + "/homework/\(detailId)"
        case .submitHomework(let homeworkId):
            return baseURIHomework + "/homework/\(homeworkId)"
        case .rejectHomework(let homeworkId):
            return baseURIHomework + "/homework/reject/\(homeworkId)"
        case .getUserList:
            return baseURIHomework + "/user/list"
            
        }
    }
    
    var header: HTTPHeaders? {
        switch self {
        default:
            return ["Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyMDM4MTM2MCwianRpIjoiNmQ0OWI4NzAtZGZhNS00MzBiLWIxMDItNjdlYmI5MjFmOTMzIiwibmJmIjoxNjIwMzgxMzYwLCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoiY2tkZHlkMTIwMkBkYXVtLm5ldCIsImV4cCI6MTYyMDQ2Nzc2MH0.7gjXJBm8q4zMlBFR2mwz61jZFnG81Vcty4L9YHv88I8"]
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
        case .getHomeworkContent(let homeworkId):
            return ["homeworkId":homeworkId]
        case .createHomework(let major, let endDate, let studentEmail, let description, let title):
            return ["major":major, "endDate":endDate, "studentEmail":studentEmail, "description":description, "title":title]
        case .deleteHomework(let deleteId):
            return ["deleteId":deleteId]
        case .submitHomework(let homeworkId):
            return ["homeworkId":homeworkId]
        case .rejectHomework(let homeworkId):
            return ["homeworkId":homeworkId]
        default : return [:]
        }
    }
}
