//
//  HTTPClient.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

let baseURINotice = "http://211.38.86.92:8001/"
let baseURIHomework = "http://211.38.86.92:8001"

protocol HTTPClientProvider {
    func get(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest
    func post(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest
    func put(url: String, params: Parameters?, header: HTTPHeaders)-> DataRequest
    func delete(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest
    func patch(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest
}

class HTTPClient: HTTPClientProvider {
    func get(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest {
        AF.request( url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: header,
                   interceptor: nil)
    }
    
    func post(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest {
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: header,
                   interceptor: nil)
    }
    
    func put(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest {
        AF.request(url,
                   method: .put,
                   parameters: params,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: header,
                   interceptor: nil)
    }
    
    func delete(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest {
        AF.request(url,
                   method: .delete,
                   parameters: params,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: header,
                   interceptor: nil)
    }
    
    func patch(url: String, params: Parameters?, header: HTTPHeaders) -> DataRequest {
        AF.request(url,
                   method: .patch,
                   parameters: params,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: header,
                   interceptor: nil)
    }
}
