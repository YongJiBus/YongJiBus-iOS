//
//  BusRouter.swift
//  YongJiBus
//
//  Created by 김도경 on 4/29/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Alamofire
import Foundation

enum BusRouter {
    case getBusArrivalTime(routeId: String)
}

extension BusRouter: BaseRouter {
    var baseURL: String {
        switch self {
        case .getBusArrivalTime(let routeId):
            return APIKey.makeRequestUrl(routeId: routeId)
        }
    }
    
    var path: String {
        ""
    }
    
    var parameter: RequestParams {
        .none
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBusArrivalTime:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getBusArrivalTime:
            return nil
        }
    }
}
