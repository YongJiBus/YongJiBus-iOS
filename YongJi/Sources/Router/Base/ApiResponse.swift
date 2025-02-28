//
//  ApiResponse.swift
//  YongJiBus
//
//  Created by 김도경 on 2/22/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//


struct ApiResponse<T: Decodable>: Decodable {
    let status: Int 
    let data: T
}
