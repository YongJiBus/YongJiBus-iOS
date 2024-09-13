//
//  TimeViewViewModel.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/07/01.
//

import Foundation

class ShuttleViewViewModel : ObservableObject {

    @Published var timeList : [ShuttleTime] = []
    
    init() {
        setList()
    }
    
    //LocalData의 json 파일 가져오기
    func load() -> Data? {
        let fileNm = {
            switch DataManager.getData(key: .weekend) as! Bool{
            case false:
                return TableType.myongji.type
            case true:
                return TableType.weekend.type
            }
        }()
        
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }

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
                return Int(time.count) ?? 0
            }
        }
        return 0
    }
}
