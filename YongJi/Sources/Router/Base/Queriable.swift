//
//  Queriable.swift
//  YongJiBus
//
//  Created by 김도경 on 11/16/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//
import Foundation

protocol Queriable {
    var queryItems: [URLQueryItem] { get }
}

extension Queriable {
    var key: String { get { "" } set { } }
    var value: String { get { "" } set { } }
    
    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: key, value: value)]
    }
    
    func toQueryParameter() -> Dictionary<String, String> {
        var result = [String: String]()
        for item in queryItems {
            if let value = item.value {
                result[item.name] = value
            }
        }
        return result
    }
}
