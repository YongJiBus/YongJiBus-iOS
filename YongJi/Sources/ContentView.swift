//
//  ContentView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/02.
//

import SwiftUI

struct ContentView: View {
    @State var currentTab : TopBarType = .MyongJi
    @EnvironmentObject var appViewModel : AppViewModel
    @EnvironmentObject var shuttleViewModel : ShuttleViewViewModel

    var body: some View {
        VStack{
            HeaderView(topBarType: $currentTab)
            TabView(selection: $currentTab){
                ShuttleView()
                    .tabItem {
                        Image(systemName: "m.circle.fill")
                        Text("명지대역")
                    }
                    .toolbarBackground(.white, for: .tabBar)
                    .tag(TopBarType.MyongJi)
                    .environmentObject(shuttleViewModel)
                StationView()
                    .tabItem{
                        Image(systemName: "g.circle.fill")
                        Text("기흥역")
                    }
                    .toolbarBackground(.white, for: .tabBar)
                    .tag(TopBarType.Giheung)
                SettingView()
                    .tabItem {
                        Image(systemName: "s.circle.fill")
                        Text("설정")
                    }
                    .tag(TopBarType.Setting)
            }
            
            .ignoresSafeArea()
            .onAppear{
                if appViewModel.isHolidayAuto {
                    appViewModel.fetchDayType()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                if appViewModel.isHolidayAuto {
                    appViewModel.fetchDayType()
                }
            }
        }
        .environmentObject(appViewModel)
        .background(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ShuttleViewViewModel())
            .environmentObject(AppViewModel())
    }
}
