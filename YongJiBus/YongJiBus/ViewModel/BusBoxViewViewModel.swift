//
//  BusBoxViewViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//

import Foundation
import Alamofire

class BusBoxViewViewModel : MyXMLParser , ObservableObject {
    
    @Published var text : String = "정보 없음"
    
    func load(_ busNumber : BusNumber) {
        AF.request(APIKey.makeRequestUrl(routeId: busNumber.route))
            .responseData { (response) in
                switch response.result {
                case .success(let result):
                    let parser = XMLParser(data: result)
                    parser.delegate = self
                    parser.parse()
                    if let time = self.busTime?.response.msgBody.busArrivalItem.predictTime1 {
                        self.text = time
                        self.text.append(" 분 남음")
                    }
                case .failure:
                    self.text = "다시 시도해주세요"
                }
        }
    }
}
