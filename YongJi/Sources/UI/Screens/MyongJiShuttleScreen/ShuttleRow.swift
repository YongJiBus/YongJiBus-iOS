//
//  TimeRow.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/07/01.
//

import SwiftUI

struct ShuttleRow: View {
    let time : ShuttleTime
    
    @EnvironmentObject var viewModel : ShuttleViewViewModel
    
    @State private var isExpanded = false
    @State private var selectedTime = Date()
    @State private var arrivalTimes: [Date] = [] // 사용자가 입력한 도착 시간들을 저장
    @State private var isButtonDisabled = false  // 버튼 비활성화 상태를 관리하는 변수
    
    // 최대 입력 가능한 시간 개수
    private let maxEntries = 5
    
    // 더 입력 가능한지 확인하는 computed property
    private var canAddMore: Bool {
        arrivalTimes.count < maxEntries
    }
    
    // 예상 도착 시간을 Date로 변환하는 computed property 추가
    private var predictedDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time.predTime) ?? Date()
    }
    
    // 선택 가능한 시간 범위 설정
    private var timeRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .minute, value: -10, to: predictedDate) ?? Date()
        let endTime = calendar.date(byAdding: .minute, value: 10, to: predictedDate) ?? Date()
    
        return startTime...endTime

    }
    
    var body: some View {
        VStack(spacing: 0) {
            row
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                    
                }
            
            if isExpanded {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        if !arrivalTimes.isEmpty {
                            Text("실제 도착 시간")
                            ForEach(arrivalTimes, id: \.self) { time in
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundStyle(.gray)
                                    Text(timeString(from: time))
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                            }
                            
                            Divider()
                        }
                        
                        HStack {
                            Text("도착 시간 입력")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.black)
                            Spacer()
                            DatePicker("도착 시간",
                                     selection: $selectedTime,
                                     in: timeRange,
                                     displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .disabled(!canAddMore || isButtonDisabled)
                            
                            Button(action: {
                                if canAddMore && !isButtonDisabled {
                                    isButtonDisabled = true  // 버튼 비활성화
                                    arrivalTimes.append(selectedTime)
                                    
                                    // 1초 후에 버튼 다시 활성화
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        isButtonDisabled = false
                                    }
                                }
                            }) {
                                Text("추가")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        (canAddMore && !isButtonDisabled) ? Color.blue : Color.gray
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .disabled(!canAddMore || isButtonDisabled)
                        }
                        
                        if !canAddMore {
                            Text("최대 \(maxEntries)개까지만 입력 가능합니다")
                                .font(.system(size: 12))
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .frame(maxWidth: .infinity)
                .background(Color("RowColor").opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.top,5)
            }
        }
    }
    
    // Date를 시간 문자열로 변환하는 헬퍼 함수
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private var row : some View {
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


