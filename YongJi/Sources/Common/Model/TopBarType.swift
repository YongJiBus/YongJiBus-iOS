//
//  TopBarType.swift
//  YongJiBus
//
//  Created by 김도경 on 2/19/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation

enum TopBarType {
    case MyongJi
    case Giheung
    case Taxi
    case Setting
    
    var text : String {
        switch self {
        case .MyongJi:
            "명지대역"
        case .Giheung:
            "기흥역"
        case .Taxi:
            "택시 카풀"
        case .Setting:
            "설정"
        }
    }
}
