//
//  RequestParams.swift
//  YongJiBus
//
//  Created by bryan on 11/16/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//

enum RequestParams {
    case query(_ parameter: Queriable)
    case body(_ parameter: Encodable)
    case none
}
