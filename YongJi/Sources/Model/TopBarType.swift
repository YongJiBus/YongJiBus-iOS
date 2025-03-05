//
//  TopBarType.swift
//  YongJiBus
//
//  Created by 김도경 on 3/4/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//


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
    case Setting
    
    var text : String {
        switch self {
        case .MyongJi:
            "명지대역"
        case .Giheung:
            "기흥역"
        case .Setting:
            "설정"
        }
    }
}
