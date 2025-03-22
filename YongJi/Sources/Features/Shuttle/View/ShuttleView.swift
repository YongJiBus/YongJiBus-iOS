//
//  ShuttleView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/06.
//195,168,246

import SwiftUI

struct ShuttleView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject private var viewModel : ShuttleViewViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(BusNumber.allCases, id: \.self) { busNumber in
                        BusBoxView(busNumber)
                    }
                } // HStack
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            ShuttleTimeView()
                .environmentObject(viewModel) // ViewModel 전달
        }
        .background(.white)
    }
}

struct MyongJiView_Previews: PreviewProvider {
    static var previews: some View {
        ShuttleView()
            .environmentObject(AppViewModel())
            .environmentObject(ShuttleViewViewModel())
    }
}
