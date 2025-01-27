//
//  StationTimeView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/06.
//

import SwiftUI

struct StationView: View {
    
    @ObservedObject var viewModel = StationViewViewModel()
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack{
            ScrollViewReader { value in
                VStack{
                    if appViewModel.isHoliday {
                        
                        StationHolidayView
                    } else {
                        topHeader()
                        StationView
                            .onAppear{
                                value.scrollTo(viewModel.nearBus(), anchor: .top)
                            }
                    }
                }
            }
        }//Vstack
        .background(.white)
    }
    
    var StationView : some View {
        ScrollView{
            ForEach(viewModel.timeList){ time in
                StationTimeRow(stationTime: time)
                    .padding(.horizontal)
                    .padding(.vertical, -2)
                    .id(time.id)
            }
        }
    }
    
    var StationHolidayView : some View {
        Text("주말 및 공휴일에는 기흥 셔틀은 운행하지 않습니다.")
    }
}
struct topHeader : View {
    var body: some View {
        HStack{
            Text("순번")
                .font(.headline)
                .bold().foregroundStyle(.black)
                .padding(.leading)
            Spacer()
            Text("학교출발")
                .font(.headline)
                .bold().foregroundStyle(.black)
            Spacer()
            Text("기흥역도착")
                .font(.headline)
                .bold().foregroundStyle(.black)
            Spacer()
            Text("학교도착")
                .font(.headline)
                .bold().foregroundStyle(.black)
            Spacer()
            Text("운행대수")
                .font(.headline)
                .bold().foregroundStyle(.black)
        }
        .padding(.horizontal)
    }
}

struct StationTimeView_Previews: PreviewProvider {
    static var previews: some View {
        StationView().environmentObject(AppViewModel())
    }
}
