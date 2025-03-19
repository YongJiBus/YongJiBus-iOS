import Foundation
import SwiftUI

class UserManager {
    static let shared = UserManager()
    
    private let userDefaultsKey = "userInfo"
    private let secureDataManager = SecureDataManager.shared
    
    private init() {
        // 앱 시작 시 로그인 상태 확인
        checkLoginStatus()
    }
    
    private var _currentUser: UserInfo?
    var currentUser: UserInfo? {
        get {
            if _currentUser == nil {
                _currentUser = loadUserInfo()
            }
            return _currentUser
        }
        set {
            _currentUser = newValue
            if let user = newValue {
                saveUserInfo(user)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return currentUser?.isLoggedIn ?? false
    }
    
    private var _isUser = false
    
    var isUser: Bool {
        return _isUser
    }
    
    private func saveUserInfo(_ userInfo: UserInfo) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userInfo)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Error saving user info: \(error)")
        }
    }
    
    private func loadUserInfo() -> UserInfo? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserInfo.self, from: data)
        } catch {
            print("Error loading user info: \(error)")
            return nil
        }
    }
    
    private func checkLoginStatus() {
        // 저장된 사용자 정보가 있는지 확인
        if let userInfo = loadUserInfo() {
            // 토큰이 있는지 확인
            let accessToken = secureDataManager.getData(label: .accessToken)
            let refreshToken = secureDataManager.getData(label: .refreshToken)
            
            if accessToken != "Error" && refreshToken != "Error" {
                // 토큰이 유효한 경우 로그인 상태 유지
                _currentUser = userInfo
                _isUser = true
            } else {
                // 토큰이 없는 경우 로그아웃
                logout()
            }
        }
    }
    
    func saveUser(email: String, name: String, nickname: String) {
        let userInfo = UserInfo(
            email: email,
            name: name,
            nickname: nickname,
            isLoggedIn: true
        )
        _currentUser = userInfo
        _isUser = true
        saveUserInfo(userInfo)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        _currentUser = nil
        _isUser = false
        secureDataManager.clearTokens()
    }
    
    func signout() {
        // 로그아웃과 동일한 작업을 수행
        // 회원 탈퇴는 서버에서 처리되므로 로컬에서는 로그아웃과 동일하게 처리
        logout()
    }
} 
