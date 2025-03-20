//
//  ArrivalTimeListReponseDTO.swift
//  YongJiBus
//
//  Created by 김도경 on 2/4/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation

struct ArrivalTimeListReponseDTO : Codable {
    let busId : Int
    let arrivalTimes : [String]
}
