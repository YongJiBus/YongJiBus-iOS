//
//  ShuttleView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/06.
//195,168,246

import SwiftUI

struct ShuttleView: View {
    
    var body: some View {
        VStack{
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(BusNumber.allCases, id: \.self){ busNumber in
                        BusBoxView(busNumber)
                    }
                } // HStack
            }
            .padding(.horizontal, 20)
            ShuttleTimeView()
        }//VStack
        .background(.white)
    }//body
}

struct MyongJiView_Previews: PreviewProvider {
    static var previews: some View {
        ShuttleView()
    }
}
