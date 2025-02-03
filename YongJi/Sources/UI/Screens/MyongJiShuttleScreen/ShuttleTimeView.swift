//
//  TimeView.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/06/29.
//

import SwiftUI

struct ShuttleTimeView: View {
    
    @ObservedObject var viewModel = ShuttleViewViewModel()
        
    var body: some View {
        ScrollViewReader { value in
            VStack{
                listHeader()
                ScrollView{
                    ForEach(viewModel.timeList) { time in
                        ShuttleRow(time: time)
                            .padding(.horizontal)
                            .padding(.vertical, -2)
                            .id(time.id)
                            .environmentObject(viewModel)
                        
                    }
                }
                
            }
            .onAppear{
               viewModel.setList()
                    value.scrollTo(viewModel.nearShuttle(), anchor: .top)
            }
        }
    }//body
}

struct listHeader : View{
    var body: some View {
        HStack{
            Text("순번")
                .frame(width: 80)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
            Text("운행경로")
                .frame(width: 70)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
            Spacer()
            //출발 시각
            Text("출발시각")
                .frame(width: 60)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
            //진입로 경우 시간
            Text("경유시각")
                .frame(width: 75)
                .bold()
                .font(.headline)
                .padding()
                .foregroundStyle(.black)
        }
        .frame(height: 30)
    }
}


struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        ShuttleTimeView()
    }
}
