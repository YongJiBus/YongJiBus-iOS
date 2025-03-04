import Foundation
import SwiftUI

class UserManager {
    static let shared = UserManager()
    
    private let userDefaultsKey = "userInfo"
    private let secureDataManager = SecureDataManager.shared
    
    private init() {}
    
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
    
    func saveUser(email: String, name: String, nickname: String) {
        let userInfo = UserInfo(
            email: email,
            name: name,
            nickname: nickname,
            isLoggedIn: true
        )
        _currentUser = userInfo
        _isUser = true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        _currentUser = nil
        secureDataManager.clearTokens()
    }
} 
