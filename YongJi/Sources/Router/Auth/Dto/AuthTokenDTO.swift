//
//  AuthTokenDTO.swift
//  YongJiBus
//
//  Created by 김도경 on 2/28/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

struct AuthTokenDTO : Decodable {
    let accessToken : String
    let refreshToken : String 
}
