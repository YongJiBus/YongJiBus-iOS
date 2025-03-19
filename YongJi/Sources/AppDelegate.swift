//
//  AppDelegate.swift
//  YongJiBus
//
//  Created by 김도경 on 3/11/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//
import Firebase
import FirebaseMessaging
import UserNotifications
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase 초기화
        FirebaseApp.configure()
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        // FCM 델리게이트 설정
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        if let token = fcmToken {
            do {
                try SecureDataManager.shared.saveFcmToken(fcmToken: token)
            } catch(let error) {
                print(error)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 사용자가 알림을 탭했을 때 호출되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // 채팅 알림인지 확인
        if let type = userInfo["type"] as? String, type == "chat" {
            // 채팅방 ID 추출
            if let roomId = userInfo["chatRoomId"] as? Int64 {
                // AppViewModel을 통해 채팅방으로 이동
                DispatchQueue.main.async {
                    AppViewModel.shared.navigateToChatRoom(roomId: roomId)
                }
            }
        }
        
        completionHandler()
    }
}
