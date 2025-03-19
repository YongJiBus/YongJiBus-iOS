//
//  SecureDataManager.swift
//  YongJiBus
//
//  Created by 김도경 on 3/1/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import Security
import RxSwift

enum TokenType : String {
    case accessToken
    case refreshToken
    case fcmToken
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case duplicatedItem
    case unhandledError(status: OSStatus)
}

class SecureDataManager {
    static let shared = SecureDataManager()
    
    let serviceName = "YongJi"
    let appName = "YongJi"
    
    private init(){
    }
    
    func saveToken(authToken: AuthTokenDTO) throws {
        clearTokens()
        let accessStatus = self.setData(authToken.accessToken, label: .accessToken)
        
        let refreshStatus = self.setData(authToken.refreshToken, label: .refreshToken)
        
        if accessStatus == errSecSuccess && refreshStatus == errSecSuccess {
        } else if accessStatus == errSecDuplicateItem || refreshStatus == errSecDuplicateItem {
            throw KeychainError.unhandledError(status: accessStatus)
        }
    }
    
    func saveFcmToken(fcmToken : String) throws {
        let fcmStatus = self.setData(fcmToken, label: .fcmToken)
        if fcmStatus == errSecDuplicateItem {
            throw KeychainError.unhandledError(status: fcmStatus)
        }
    }
    
    internal func setData(_ token: String, label : TokenType)-> OSStatus {
        let keychainItem = [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: label.rawValue,
                    kSecAttrService: serviceName,
                    kSecValueData: token.data(using: .utf8, allowLossyConversion: false)!
                ] as NSDictionary
        
        let status = SecItemAdd(keychainItem as CFDictionary, nil)
        return status
    }
    
    internal func getData(label : TokenType) -> String {
        let searchQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                     kSecAttrAccount: label.rawValue,
                                  kSecAttrService : serviceName,
                                    kSecReturnData: kCFBooleanTrue!]
        var result: AnyObject?
        let searchStatus = SecItemCopyMatching(searchQuery, &result)
        
        if searchStatus == errSecSuccess {
            guard let token = result as? Data else { return "Error"}
            print("SecureDataManager: 불러오기 성공")
            return String(data: token, encoding: String.Encoding.utf8)!
        } else {
            return "SecureDataManager: 불러오기 실패, status = \(searchStatus)"
        }
    }
    
    // Clear tokens from keychain
    func clearTokens() {
        // Delete access token
        deleteToken(type: .accessToken)
        
        // Delete refresh token
        deleteToken(type: .refreshToken)
    }
    
    private func deleteToken(type: TokenType) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.rawValue,
            kSecAttrService: serviceName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("SecureDataManager: 토큰 삭제 실패, type = \(type.rawValue), status = \(status)")
        }
    }
}
