//
//  TimeViewViewModel.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/07/01.
//

import Foundation
import RxSwift

class ShuttleViewViewModel : ObservableObject {

    private let arrivalTimeRepository = ArrivalTimeRepository()
    
    @Published var timeList : [ShuttleTime] = []

    @Published var arrivalTimeModels: [ArrivalTimeList] = []
    
    init() {
        setList()
    }

    func saveArrivalTime(busId: Int, date: Date, isHoliday: Bool){
        let requestDTO = SaveArrivalTimeRequestDTO(busId: busId, arrivalTime: date, isHoliday: isHoliday)
        arrivalTimeRepository.saveArrivalTime(requestDTO: requestDTO)
        
        // Convert date to string
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        
        // Update or add the arrival time model
        if let index = arrivalTimeModels.firstIndex(where: { $0.timeId == busId }) {
            arrivalTimeModels[index].arrivalTimes.append(timeString)
        } else {
            arrivalTimeModels.append(ArrivalTimeModel(timeId: busId, arrivalTimes: [timeString]))
        }
    }

    func getArrivalTimes(for timeId: Int) -> [String] {
        return arrivalTimeModels.first(where: { $0.timeId == timeId })?.arrivalTimes ?? []
    }
    
    //LocalData의 json 파일 가져오기
    func load() -> Data? {
        let fileNm = {
            switch DataManager.isHoliday {
            case false:
                return TableType.myongji.type
            case true:
                return TableType.weekend.type
            }
        }()
        
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: "json") else {
            print(Bundle.main)
            return nil
        }

        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
    //Json Decoding
    func setList(){
        if let data = load(){
            if let result = try? JSONDecoder().decode(ShuttleTimeList.self, from: data){
                self.timeList = result.ShuttleTimes
            }
        }
    }
    
    //현재 시간과 가까운 셔틀 조회
    func nearShuttle() -> Int {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let hour = calendar.component(.hour, from: date)
        
        for time in timeList {
            if time.predTime.contains(String(hour)) {
                return time.id
            }
        }
        return 0
    }
}
