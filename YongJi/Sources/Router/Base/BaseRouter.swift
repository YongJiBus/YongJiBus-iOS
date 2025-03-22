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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch header {
        case .auth:
            // Get access token from SecureDataManager
            let accessToken = SecureDataManager.shared.getData(label: .accessToken)
            // Add Bearer token to Authorization header
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        default:
            break
        }
        return request
    }
     
    private func makePrameterForRequest(to request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        switch parameter {
        case .query(let parameters):
            // 새로운 Queriable 프로토콜을 사용하여 queryItems 직접 사용
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = parameters.queryItems
            request.url = components?.url
        case .body(let parameters):
            let body = try JSONEncoder().encode(parameters)
            request.httpBody = body
        case .none:
            break
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
