//
//  BusTime.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//
import Foundation

// MARK: - Welcome3
struct BusTime : Decodable {
    var response: Response
}

// MARK: - Response
struct Response : Decodable {
    var comMsgHeader: String
    var msgHeader: MsgHeader
    var msgBody: MsgBody
}

// MARK: - MsgBody
struct MsgBody : Decodable{
    var busArrivalItem: BusArrivalItem
}

// MARK: - BusArrivalItem
struct BusArrivalItem : Decodable {
    var flag, locationNo1, locationNo2, lowPlate1: String
    var lowPlate2, plateNo1, plateNo2, predictTime1: String
    var predictTime2, remainSeatCnt1, remainSeatCnt2, routeID: String
    var staOrder, stationID: String
}

// MARK: - MsgHeader
struct MsgHeader : Decodable {
    var queryTime, resultCode, resultMessage: String
}
