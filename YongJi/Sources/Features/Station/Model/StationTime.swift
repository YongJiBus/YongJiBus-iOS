//
//  StationTime.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/06.
//

import Foundation

struct StationTimeList : Codable {
    let StationTimes : [StationTime]
}

struct StationTime : Identifiable, Codable {
    
    let id : Int
    let startTime : String
    let stationArrival : String
    let schoolArrival : String
    let runCount : Int
    
    init(id: Int, startTime: String, stationArrival: String, schoolArrival: String, runCount: Int) {
        self.id = id
        self.startTime = startTime
        self.stationArrival = stationArrival
        self.schoolArrival = schoolArrival
        self.runCount = runCount
    }
}
