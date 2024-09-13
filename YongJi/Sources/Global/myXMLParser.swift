//
//  myXMLParser.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//

import Foundation

class MyXMLParser: NSObject, XMLParserDelegate {
    private var currentElement: String?
    var busTime: BusTime?
    
    
    // XMLParserDelegate 메서드 중 시작 태그를 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "response" {
            busTime = BusTime(response: Response(comMsgHeader: "", msgHeader: MsgHeader(queryTime: "", resultCode: "", resultMessage: ""), msgBody: MsgBody(busArrivalItem: BusArrivalItem(flag: "", locationNo1: "", locationNo2: "", lowPlate1: "", lowPlate2: "", plateNo1: "", plateNo2: "", predictTime1: "", predictTime2: "", remainSeatCnt1: "", remainSeatCnt2: "", routeID: "", staOrder: "", stationID: ""))))
        }
    }
    
    // XMLParserDelegate 메서드 중 태그의 텍스트를 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let element = currentElement {
            if element == "comMsgHeader" {
                busTime?.response.comMsgHeader = string
            } else if element == "queryTime" {
                busTime?.response.msgHeader.queryTime = string
            } else if element == "resultCode" {
                busTime?.response.msgHeader.resultCode = string
            } else if element == "resultMessage" {
                busTime?.response.msgHeader.resultMessage = string
            } else if element == "flag" {
                busTime?.response.msgBody.busArrivalItem.flag = string
            } else if element == "locationNo1" {
                busTime?.response.msgBody.busArrivalItem.locationNo1 = string
            } else if element == "locationNo2" {
                busTime?.response.msgBody.busArrivalItem.locationNo2 = string
            } else if element == "lowPlate1" {
                busTime?.response.msgBody.busArrivalItem.lowPlate1 = string
            } else if element == "lowPlate2" {
                busTime?.response.msgBody.busArrivalItem.lowPlate2 = string
            } else if element == "plateNo1" {
                busTime?.response.msgBody.busArrivalItem.plateNo1 = string
            } else if element == "plateNo2" {
                busTime?.response.msgBody.busArrivalItem.plateNo2 = string
            } else if element == "predictTime1" {
                busTime?.response.msgBody.busArrivalItem.predictTime1 = string
            } else if element == "predictTime2" {
                busTime?.response.msgBody.busArrivalItem.predictTime2 = string
            } else if element == "remainSeatCnt1" {
                busTime?.response.msgBody.busArrivalItem.remainSeatCnt1 = string
            } else if element == "remainSeatCnt2" {
                busTime?.response.msgBody.busArrivalItem.remainSeatCnt2 = string
            } else if element == "routeId" {
                busTime?.response.msgBody.busArrivalItem.routeID = string
            } else if element == "staOrder" {
                busTime?.response.msgBody.busArrivalItem.staOrder = string
            } else if element == "stationId" {
                busTime?.response.msgBody.busArrivalItem.stationID = string
            }
        }
    }
    
    // XMLParserDelegate 메서드 중 종료 태그를 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = nil
    }
    
}
