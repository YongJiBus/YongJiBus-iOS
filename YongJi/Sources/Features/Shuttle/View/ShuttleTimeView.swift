//
//  TimeView.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/06/29.
//

import SwiftUI

struct ShuttleTimeView: View {
    
    @EnvironmentObject var viewModel: ShuttleViewViewModel
    @State private var showInfoAt18 = false
        
    var body: some View {
        ScrollViewReader { value in
            VStack{
                listHeader
                ScrollView{
                    LazyVStack {
                        ForEach(viewModel.timeList.indices, id: \.self) { index in
                            let time = viewModel.timeList[index]
                            
                            // 18:00 바로 다음에 정보 배너 표시
                            if time.id == 58 {
                                importantInfoBanner
                                    .padding(.horizontal)
                                    .padding(.vertical, -2)
                                    .onAppear {
                                        showInfoAt18 = true
                                    }
                            }
                            
                            ShuttleRow(time: time)
                                .padding(.horizontal)
                                .padding(.vertical, -2)
                                .id(time.id)
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.setList()
                showInfoAt18 = false
                value.scrollTo(viewModel.nearShuttle(), anchor: .top)
            }
        }
    }//body
    
    // 중요 정보 배너
    private var importantInfoBanner: some View {
        VStack(spacing: 8) {
            
            HStack(alignment: .top) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color("RowNumColor"))
                    .font(.system(size: 16))
                    .padding(.top, 3)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("※ 18:00 이후 시내셔틀은 제1공학관까지만 운행")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("※ 18:00 이후 진입로셔틀은 명진당까지만 운행")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(10)
        .background(Color("RowNumColor").opacity(0.15))
        .cornerRadius(10)
    }
    
    var listHeader : some View {
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

struct ShuttleTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ShuttleTimeView()
            .environmentObject(ShuttleViewViewModel())
    }
}
