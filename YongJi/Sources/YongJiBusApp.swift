//
//  YongJiBusApp.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/02.
//

import Firebase
import SwiftUI


@main
struct YongJiBusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var appViewModel = AppViewModel()
    @StateObject var shuttleViewModel = ShuttleViewViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(shuttleViewModel)
                .onAppear {
                }
        }
    }
}
