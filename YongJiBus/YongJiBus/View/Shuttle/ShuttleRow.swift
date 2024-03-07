//
//  TimeRow.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/07/01.
//

import SwiftUI

struct ShuttleRow: View {
    let time : ShuttleTime


    
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
                Text(time.count)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color("RowNumColor"))
            }
            .frame(width: 50)
            Text(time.type ?? "시내") // 방학 때는 시내 셔틀만 운행
                .frame(width: 100)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
            Spacer()
            //출발 시각
            Text(time.startTime)
                .frame(width: 50)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
                .padding()
            //진입로 경우 시간
            Text(time.predTime)
                .frame(width: 50)
                .bold()
                .font(.headline)
                .foregroundStyle(.black)
                .padding()
        }
        .frame(height: 50)
        .background(Color("RowColor"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct TimeRow_Previews: PreviewProvider {
    static var previews: some View {
        ShuttleRow(time: ShuttleTime(count: "1", type: "명지대", startTime: "08:00", predTime: "08:15"))
    }
}

