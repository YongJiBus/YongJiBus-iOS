//
//  SignUpResponseDTO.swift
//  YongJiBus
//
//  Created by 김도경 on 2/28/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

struct SignUpResponseDTO : Decodable {
    let accessToken : String
    let refreshToken : String 
}
