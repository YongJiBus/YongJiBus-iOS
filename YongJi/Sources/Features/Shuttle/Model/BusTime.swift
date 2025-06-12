//
//  BusTime.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//
import Foundation

// MARK: - BusTime
struct BusTime: Decodable {
    var response: Response
}

// MARK: - Response
struct Response: Decodable {
    var comMsgHeader: String
    var msgHeader: MsgHeader
    var msgBody: MsgBody?
}

// MARK: - MsgHeader
struct MsgHeader: Decodable {
    var queryTime: String
    var resultCode: Int
    var resultMessage: String
}

// MARK: - MsgBody
struct MsgBody: Decodable {
    var busArrivalItem: BusArrivalItem
}

// MARK: - BusArrivalItem
struct BusArrivalItem: Decodable {
    var crowded1, crowded2: IntOrString
    var flag: IntOrString
    var locationNo1, locationNo2: IntOrString
    var lowPlate1, lowPlate2: IntOrString
    var plateNo1, plateNo2: IntOrString
    var predictTime1, predictTime2: IntOrString
    var remainSeatCnt1, remainSeatCnt2: IntOrString
    var routeDestId: Int
    var routeDestName: String
    var routeId: Int
    var routeName: String
    var routeTypeCd, staOrder, stationId: Int
    var stationNm1, stationNm2: String
    var taglessCd1, taglessCd2: IntOrString
    var turnSeq : Int
    var vehId1, vehId2: IntOrString
}

// MARK: - IntOrString
enum IntOrString: Decodable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(IntOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value is neither Int nor String"))
        }
    }
}
