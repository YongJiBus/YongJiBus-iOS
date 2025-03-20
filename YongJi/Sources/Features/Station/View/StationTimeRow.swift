//
//  StationTimeRow.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/06.
//

import SwiftUI

struct StationTimeRow: View {
    private let stationTime : StationTime
    
    init(stationTime: StationTime) {
        self.stationTime = stationTime
    }
    
    
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .fill(Color("RowNumColor"))
                    .frame(width: 30, height: 30)
                Text(String(stationTime.id + 1))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding()
            //출발 시간
            Text(stationTime.startTime)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
            Spacer()
            //기흥역 도착시간
            Text(stationTime.stationArrival)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
            Spacer()
            //학교 도착시간
            Text(stationTime.schoolArrival)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
            Spacer()
            //운행 대수
            Text(String(stationTime.runCount))
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
                .padding()
        }//HStack
        .frame(height: 55)
        .background(Color("RowColor"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct StationTimeRow_Previews: PreviewProvider {
    static var previews: some View {
        StationTimeRow(stationTime: StationTime(id: 1, startTime: "08:00", stationArrival: "08:15", schoolArrival: "08:30", runCount: 2))
    }
}
