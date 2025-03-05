//
//  StationViewViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/06.
//

import Foundation


class StationViewViewModel : ObservableObject {

    var timeList : [StationTime] = []
    
    init(){
        setList()
    }
   
    func load() -> Data? {
        let fileNm : String = "GiheungStationTimeTable"
        let extensionType = "json"
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
    func setList(){
        if let data = load() {
            if let result = try? JSONDecoder().decode(StationTimeList.self, from: data){
                self.timeList = result.StationTimes
            }
        }
    }
    
    func nearBus() -> Int {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let hour = calendar.component(.hour, from: date)
        
        for time in timeList {
            if time.startTime.contains(String(hour)) {
                return time.id
            }
        }
        return 0
    }
}
