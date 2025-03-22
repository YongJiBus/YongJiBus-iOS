//
//  Time.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/06/29.
//  명지대역 셔틀 시간표

import Foundation

struct ShuttleTimeList : Codable{
    let ShuttleTimes : [ShuttleTime]
}

struct ShuttleTime : Identifiable, Codable {
    let id : Int
    let type : String?
    let startTime : String
    let predTime : String
    
    init(id: Int, type: String?, startTime: String, predTime: String) {
        self.id = id
        self.type = type
        self.startTime = startTime
        self.predTime = predTime
    }
    
    private enum CodingKeys : String , CodingKey {
        case id = "순번"
        case type = "운행 구분"
        case startTime = "출발 시각"
        case predTime = "진입로경유 예정 시간"
    }
}

