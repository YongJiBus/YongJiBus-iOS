//
//  LoginViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2/23/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isFormValid = false
    
    private var isEmailValid = false
    private var isPasswordValid = false
    
    func validateEmail(_ newValue: String) {
        if newValue.count > 30 {
            email = String(newValue.prefix(30))
        } else {
            email = newValue
        }
        // 이메일 형식 검증
        let emailRegex = "[A-Z0-9a-z._%+-]+@mju\\.ac\\.kr"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: newValue)
        updateFormValidity()
    }
    
    func validatePassword(_ newValue: String) {
        // 비밀번호 유효성 검사 (최소 8자 이상)
        if newValue.count > 20 {
            password = String(newValue.prefix(20))
        } else {
            password = newValue
        }
        isPasswordValid = password.count >= 8
        updateFormValidity()
    }
    
    private func updateFormValidity() {
        isFormValid = isEmailValid && isPasswordValid
    }
    
    func login() {
        AuthRepository.shared.login(email: email, password: password)
            .subscribe(
                onSuccess: { [weak self] token in
                    // TODO: 토큰 저장 및 로그인 성공 처리
                },
                onFailure: { [weak self] error in
                    self?.errorMessage = "로그인에 실패했습니다.\n이메일과 비밀번호를 확인해주세요."
                }
            )
            .disposed(by: disposeBag)
    }
}
