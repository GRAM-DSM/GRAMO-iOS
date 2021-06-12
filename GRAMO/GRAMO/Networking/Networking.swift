////
////  Networking.swift
////  GRAMO
////
////  Created by 장서영 on 2021/02/26.
////
//
//import Foundation
//import Alamofire
//
//let baseURINotice = "http://13.209.8.210:5000/"
//let baseURIHomework = "http://211.38.86.92:8001"
//
//public enum NetworkingAPI {
//    case getCalendarList(_ date: String)
//    case getPICU(_ date: String)
//    case getPlan(_ date: String)
//    case createPICU(_ description: String, _ date: String)
//    case createPlan(_ description: String, _ title: String, _ date: String)
//    case deletePICU(_ picuId: Int)
//    case deletePlan(_ planId: Int)
//
//    case getNoticeList(_ off_set : Int, _ limit_num : Int)
//    case getNoticeDetail(_ id: Int)
//    case createNotice(_ title: String, _ content: String)
//    case deleteNotice(_ id: Int)
//
//    case getAssHomeworkList
//    case getSubHomeworkList
//    case getOrdHomeworkList
//
//    case getHomeworkContent(_ homeworkId: Int)
//    case createHomework(_ major: String, _ endDate: String, _ studentEmail: String, _ description: String, _ title: String)
//    case deleteHomework(_ detailId: Int)
//
//    case submitHomework(_ homeworkId: Int)
//    case rejectHomework(_ homeworkId: Int)
//
//    case getUserList
//
//    var path: String {
//        switch self {
//        case .getCalendarList(let date):
//            return "calendar/\(date)"
//
//        case .getPICU(let date):
//            return "calendar/picu/\(date)"
//
//        case .createPICU:
//            return "calendar/picu"
//
//        case .deletePICU(let picuId):
//            return "calendar/picu/\(picuId)"
//
//        case .getPlan(let date):
//            return "calendar/plan/\(date)"
//
//        case .createPlan:
//            return "calendar/plan"
//
//        case .deletePlan(let picuId):
//            return "calendar/plan/\(picuId)"
//
//        case .getNoticeList(let off_set, let limit_num):
//            return baseURINotice + "/notice/\(off_set)/\(limit_num)"
//
//        case .createNotice:
//            return baseURINotice + "/notice"
//
//        case .getNoticeDetail(let id), .deleteNotice(let id):
//            return baseURINotice + "/notice/\(id)"
//
//        case .getAssHomeworkList:
//            return baseURIHomework + "/homework/assign"
//
//        case .getSubHomeworkList:
//            return baseURIHomework + "/homework/submit"
//
//        case .getOrdHomeworkList:
//            return baseURIHomework + "/homework/order"
//
//        case .getHomeworkContent(let homeworkId):
//            return baseURIHomework + "/homework/\(homeworkId)"
//
//        case .createHomework:
//            return baseURIHomework + "/homework"
//
//        case .deleteHomework(let detailId):
//            return baseURIHomework + "/homework/\(detailId)"
//
//        case .submitHomework(let homeworkId):
//            return baseURIHomework + "/homework/\(homeworkId)"
//
//        case .rejectHomework(let homeworkId):
//            return baseURIHomework + "/homework/reject/\(homeworkId)"
//
//        case .getUserList:
//            return baseURIHomework + "/user/list"
//        }
//    }
//
//    var headers: HTTPHeaders? {
//        let justToken: String = "token"
//        let UserDefault = UserDefaults.standard
//
//        UserDefault.set(justToken, forKey: "justToken")
//        UserDefault.synchronize()
//
//        guard let token = UserDefault.string(forKey: "justToken") else { return nil }
//
//        // return ["Authorization" : "Bearer" + token]
//        return [ "Content-Type" : "application/json", "Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyMjcwNjgyNywianRpIjoiZjlkNjVmOWItN2I2YS00ZGI5LWIyYTUtZTRmZGNjNzAyNjVhIiwibmJmIjoxNjIyNzA2ODI3LCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoiYTAxMDk0OTAyMjE5QGdtYWlsLmNvbSIsImV4cCI6MTYyMjc5MzIyN30.UWVBXW2H5x6Z32r0XEWXY_GjCcUBjX_37Xql8mR3fYQ"]
//
//    }
//
//    var parameters: [String: Any] {
//        switch self {
//        case .createPICU(let description, let date):
//            print(["description": description, "date": date])
//            return ["description": description, "date": date]
//
//        case .createPlan(let description, let title, let date):
//            print(["description": description, "title": title, "date": date])
//            return ["description": description, "title": title, "date": date]
//
//        case .getNoticeDetail(let id):
//            return ["id":id]
//
//        case .createNotice(let title, let content):
//            return ["title":title, "content":content]
//
//        case .getHomeworkContent(let homeworkId):
//            return ["homeworkId":homeworkId]
//
//        case .createHomework(let major, let endDate, let studentEmail, let description, let title):
//            return ["major":major, "endDate":endDate, "studentEmail":studentEmail, "description":description, "title":title]
//
//        case .deleteHomework(let deleteId):
//            return ["deleteId":deleteId]
//
//        case .submitHomework(let homeworkId):
//            return ["homeworkId":homeworkId]
//
//        case .rejectHomework(let homeworkId):
//            return ["homeworkId":homeworkId]
//
//        default:
//            return [:]
//
//        }
//
//    }
//
//}
