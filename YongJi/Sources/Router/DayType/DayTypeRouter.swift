//
//  DayTypeRouter.swift
//  YongJiBus
//
//  Created by bryan on 11/16/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//

import Alamofire
import Foundation

enum DayTypeRouter {
    case getDayType(Queriable)
}

extension DayTypeRouter : BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .getDayType:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .getDayType:
            "/day"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .getDayType(let dto):
                .query(dto)
        }
    }
}
