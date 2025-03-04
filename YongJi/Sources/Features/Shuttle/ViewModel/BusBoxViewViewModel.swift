//
//  BusBoxViewViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//

import Foundation
import Alamofire

class BusBoxViewViewModel : MyXMLParser , ObservableObject {
    
    @Published var text : String = "운행 전"
    @Published var isLoading : Bool = false
    
    func load(_ busNumber : BusNumber , _ completion: @escaping ()->()) {
        AF.request(APIKey.makeRequestUrl(routeId: busNumber.route))
            .responseData { response in
                switch response.result {
                case .success(let result):
                    let parser = XMLParser(data: result)
                    parser.delegate = self
                    parser.parse()
                    if let time = self.busTime?.response.msgBody.busArrivalItem.predictTime1 {
                        if let num = Int(time){
                            if num < 2 {
                                self.text = "곧 도착"
                            } else {
                                self.text = time + " 분 남음"
                            }
                        } else {
                            self.text = "운행 전"
                        }
                    }
                    completion()
                case .failure:
                    self.text = "다시 시도해주세요"
                    completion()
                }
        }
    }
    
    func loading(){
        isLoading = true
    }
    
    func stopLoading(){
        isLoading = false
    }
}
