//
//  BaseRouter.swift
//  YongJiBus
//
//  Created by bryan on 11/16/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//

import Alamofire
import Foundation


protocol BaseRouter : URLRequestConvertible {
    var baseURL : String { get }
    var method : HTTPMethod { get }
    var path : String { get }
    var parameter : RequestParams { get }
    var header : HeaderType { get }
}

extension BaseRouter {
    public func asURLRequest() throws -> URLRequest {
        var url : URL
        var urlRequest : URLRequest
        
        if path == "" {
            // path가 공백인 경우 , appendingPathComponent를 사용하면 "/"가 하나 더 생기는 문제가 있음
            // 따로 ""인 경우로 나눠서 생성
            url = try String(baseURL+path).asURL()
            urlRequest = try URLRequest(url: url, method : method)
        } else {
            url = try baseURL.asURL()
            urlRequest = try URLRequest(url: url.appendingPathComponent(path), method : method)
        }
        urlRequest = self.makeHeaderForRequest(to: urlRequest)
        return try self.makePrameterForRequest(to: urlRequest, with: url)
    }
    
    private func makeHeaderForRequest(to request: URLRequest) -> URLRequest {
        var request = request
        switch header {
        case .basic:
            break
        }
        return request
    }
     
    private func makePrameterForRequest(to request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        switch parameter {
        case .query(let parameters):
            let queryParams = parameters.toQueryParameter().map{ URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
        case .body(let parameters):
            let body = try JSONEncoder().encode(parameters)
            request.httpBody = body
        }
        return request
    }
}


extension BaseRouter {
    var baseURL: String {
        return APIKey.backendURL
    }
    
    var header: HeaderType {
        return HeaderType.basic
    }
}
