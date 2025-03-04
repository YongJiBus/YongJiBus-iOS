//
//  UserProfileViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2/23/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//


import Foundation

class UserProfileViewModel: ObservableObject {
    private let userManager = UserManager.shared
    
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
        userManager.logout()
    }
}
