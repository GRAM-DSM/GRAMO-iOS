//
//  HTTPClient.swift
//  GRAMO
//
//  Created by 장서영 on 2021/02/26.
//

import Foundation
import Alamofire

protocol HTTPClientProvider {
    func get(_ api: NetworkingAPI) -> DataRequest
    func post(_ api: NetworkingAPI) -> DataRequest
    func patch(_ api: NetworkingAPI) -> DataRequest
    func delete(_ api: NetworkingAPI) -> DataRequest
}

class HTTPClient : HTTPClientProvider {
    
    let baseURI = String()
    
    func get(_ api: NetworkingAPI) -> DataRequest {
        return AF.request(baseURI + api.path, method: .get, parameters: api.parameter, encoding: URLEncoding.default, headers: api.header, interceptor: nil)
    }
    
    func post(_ api: NetworkingAPI) -> DataRequest {
        return AF.request(baseURI + api.path, method: .post, parameters: api.parameter, encoding: JSONEncoding.prettyPrinted, headers: api.header, interceptor: nil)
    }
    
    func patch(_ api: NetworkingAPI) -> DataRequest {
        return AF.request(baseURI + api.path, method: .patch, parameters: api.parameter, encoding: JSONEncoding.prettyPrinted, headers: api.header, interceptor: nil)
    }
    
    func delete(_ api: NetworkingAPI) -> DataRequest {
        return AF.request(baseURI + api.path, method: .delete, parameters: api.parameter, encoding: JSONEncoding.prettyPrinted, headers: api.header, interceptor: nil)
    }
}

