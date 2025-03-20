//
//  LoginViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2/23/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel: ObservableObject , AuthViewModel{

    let memberRepository = MemberRepository.shared
    private let disposeBag = DisposeBag()
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isFormValid = false
    @Published var isFinished = false
    @Published var isLoading = false
    
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
    
    func login(){
        isLoading = true
        
        AuthRepository.shared.login(email: self.email, password: self.password)
            .subscribe(
                onSuccess: { [weak self] token in
                    guard let self = self else { return }
                    
                    do {
                        try self.saveAuthToken(token: token)
                        memberRepository.getCurrentMember()
                            .subscribe(
                                onSuccess: { [weak self] member in
                                    guard let self = self else { return }
                                    UserManager.shared.saveUser(
                                        email: self.email,
                                        name: member.name,
                                        nickname: member.username
                                    )
                                },
                                onFailure: { [weak self] error in
                                    guard let self = self else { return }
                                    self.isLoading = false
                                    self.errorMessage = "회원 정보 가져오기에 실패했습니다."
                                }
                            )
                            .disposed(by: disposeBag)
                        self.registerFCMToken()
                    } catch {
                        self.isLoading = false
                        self.errorMessage = "토큰 저장에 실패하였습니다\n다시시도해주세요"
                    }
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.errorMessage = "로그인에 실패했습니다.\n이메일과 비밀번호를 확인해주세요."
                }
            )
            .disposed(by: disposeBag)
        
    }
    
    func registerFCMToken(){
        let token = SecureDataManager.shared.getData(label: .fcmToken)
        
        ChatRepository.shared.registerFCMToken(token: token)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.isLoading = false
                self.isFinished = true
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = "등록 오류 다시 가입해주세요"
            }
            .disposed(by: disposeBag)

    }
}
