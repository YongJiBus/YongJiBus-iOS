//
//  UserProfileViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2/23/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//


import Foundation
import RxSwift

class UserProfileViewModel: ObservableObject {
    private let userManager = UserManager.shared
    private let disposeBag = DisposeBag()
    
    @Published var userEmail: String = ""
    @Published var userName: String = ""
    @Published var userNickname: String = ""
    
    init() {
        loadUserInfo()
    }
    
    private func loadUserInfo() {
        if let user = userManager.currentUser {
            userEmail = user.email
            userName = user.name
            userNickname = user.nickname
        }
    }
    
    func logout() {
        AuthRepository.shared.logout()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.userManager.logout()
            } onFailure: { error in
                print("로그아웃 실패: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }

    func signout() {
        AuthRepository.shared.signout()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.userManager.signout()
            } onFailure: { error in
                print("회원탈퇴 실패: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
}
