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
    
    private var disposeBag = DisposeBag()
    
    @Published var timeList : [ShuttleTime] = []

    @Published var arrivalTimeList: [ArrivalTimeList] = []
    
    init() {
        setList()
    }

    func saveArrivalTime(busId: Int, date: Date, isHoliday: Bool) -> Single<Dictionary<String,String>>{
        let requestDTO = SaveArrivalTimeRequestDTO(busId: busId, arrivalTime: date, isHoliday: isHoliday)
        return arrivalTimeRepository.saveArrivalTime(requestDTO: requestDTO)
    }
    
    func loadArrivalTimeByBusId(busId: Int) {
        arrivalTimeRepository.getArrivalTimes(busId: busId)
            .subscribe { [weak self] dtoList in
                guard let self = self else {return}
                var updatedList = self.arrivalTimeList
                updatedList[busId].arrivalTimes = dtoList.map { $0.time }
                self.arrivalTimeList = updatedList
            } onFailure: { error in
                //print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func loadAllArrivalTimeList() {
        arrivalTimeRepository.getAllArrivalTimes()
            .subscribe { [weak self] list in
                guard let self = self else {return}
                var updatedList = self.arrivalTimeList
                for i in list {
                    updatedList[i.busId].arrivalTimes = i.arrivalTimes
                }
                self.arrivalTimeList = updatedList
            } onFailure: { error in
                //print(error)
            }
            .disposed(by: disposeBag)
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
                // 셔틀 시간표(timeList) 만큼의 도착 예정 리스트(ArrivaTimeList)를 생성
                let list = timeList.map{ ArrivalTimeList(timeId: $0.id) }
                self.arrivalTimeList = list
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
