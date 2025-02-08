//
//  TimeRow.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/07/01.
//

import RxSwift
import SwiftUI

struct ShuttleRow: View {

    @EnvironmentObject var viewModel : ShuttleViewViewModel
    private let time : ShuttleTime
    private var disposeBag = DisposeBag()

    // View 상태 관리
    @State private var isExpanded = false
    @State private var selectedTime : Date = .now
    @State private var isButtonDisabled = false
    @State private var subText : String = "도착 시간 입력"
    private var isListEmpty : Bool {
        viewModel.arrivalTimeList[time.id].arrivalTimes.isEmpty
    }
    // 예상 도착 시간 : Date
    private var predictedDate : Date = .now
    
    // 선택 가능한 시간 범위 설정
    private var timeRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .minute, value: -10, to: predictedDate) ?? Date()
        let endTime = calendar.date(byAdding: .minute, value: 10, to: predictedDate) ?? Date()
    
        return startTime...endTime
    }
    
    init(time : ShuttleTime){
        self.time = time
        predictedDate = DateFormatter.hourMinute.date(from: time.predTime) ?? Date()
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
                        if !isListEmpty {
                            Text("실제 도착 시간")
                            ForEach(viewModel.arrivalTimeList[time.id].arrivalTimes, id: \.self) { timeString in
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundStyle(.gray)
                                    Text(timeString)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                            }
                            
                            Divider()
                        }
                        
                        HStack {
                            Text(subText)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.black)
                            Spacer()
                            datePicker
                            addButton
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
        .onAppear{
            selectedTime = DateFormatter.hourMinute.date(from: time.predTime) ?? Date()
        }
    }
    
    private var datePicker : some View {
        DatePicker("도착 시간",
                 selection: $selectedTime,
                 in: timeRange,
                 displayedComponents: .hourAndMinute)
        .datePickerStyle(.compact)
        .labelsHidden()
        .disabled(isButtonDisabled)
    }
    
    private var addButton : some View {
        Button(action: {
            if !isButtonDisabled {
                isButtonDisabled = true  // 버튼 비활성화
                viewModel.saveArrivalTime(busId: time.id, date: selectedTime, isHoliday: DataManager.isHoliday)
                    .subscribe { response in
                        viewModel.loadArrivalTimeByBusId(busId: time.id)
                    } onFailure: { error in
                        subText = "전송 실패: 다시시도해주세요"
                    }
                    .disposed(by: disposeBag)

                // 1초 후에 버튼 다시 활성화
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isButtonDisabled = false
                }
            }
        }) {
            buttonText
        }
        .disabled(isButtonDisabled)
    }
    
    private var buttonText : some View {
        Text("추가")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                !isButtonDisabled ? Color.blue : Color.gray
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var row : some View {
        HStack{
            ZStack{
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
                Text("\(time.id + 1)")
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
        ShuttleRow(time: ShuttleTime(id: 1, type: "명지대", startTime: "08:00", predTime: "08:15"))
            .environmentObject(ShuttleViewViewModel())
    }
}


