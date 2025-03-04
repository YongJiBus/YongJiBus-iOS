//
//  AuthViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 3/1/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import RxSwift

protocol AuthViewModel {
}

extension AuthViewModel {
    func saveAuthToken(token : AuthTokenDTO) throws {
        try SecureDataManager.shared.saveToken(authToken: token)
    }
}
