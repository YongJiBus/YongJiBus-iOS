//
//  ContentView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/02.
//

import SwiftUI

struct ContentView: View {
    @State var currentTab : String = "명지대역"
    
    var body: some View {
        VStack{
            HeaderView(title: $currentTab)
            TabView(selection:$currentTab){
                ShuttleView()
                    .tabItem {
                        Image(systemName: "m.circle.fill")
                        Text("명지대역")
                    }
                    .toolbarBackground(.white, for: .tabBar)
                    .tag("명지대역")
                StationView()
                    .tabItem{
                        Image(systemName: "g.circle.fill")
                        Text("기흥역")
                    }
                    .toolbarBackground(.white, for: .tabBar)
                    .tag("기흥역")
                SettingView()
                    .tabItem {
                        Image(systemName: "s.circle.fill")
                        Text("설정")
                    }
                    .tag("설정")
            }
            .ignoresSafeArea()
        }
        .background(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
