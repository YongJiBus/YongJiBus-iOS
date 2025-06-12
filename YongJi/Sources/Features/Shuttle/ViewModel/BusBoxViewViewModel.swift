//
//  BusBoxViewViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//

import Alamofire
import Foundation
import RxSwift

class BusBoxViewViewModel : MyXMLParser , ObservableObject {
    
    @Published var text : String = "운행 전"
    @Published var isLoading : Bool = false
    
    private let repository = BusRepository()
    private var disposeBag = DisposeBag()
    
    func fetchBusData(_ busNumber : BusNumber, _ completion: @escaping ()->()){
        repository
            .fetchBusTime(busNumber: busNumber)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] busTime in
                guard let self = self else {return}
                switch busTime.response.msgBody?.busArrivalItem.predictTime1 {
                case .int(let time):
                    if time < 2 {
                        self.text = "곧 도착"
                    } else {
                        self.text = "\(time)분 남음"
                    }
                case .string(_):
                    self.text = "운행 전"
                case .none:
                    self.text = "운행 전"
                }
                completion()
            } onFailure: { error in
                self.text = "다시 시도해주세요"
                completion()
            }
            .disposed(by: disposeBag)
    }
    
    func loading(){
        isLoading = true
    }
    
    func stopLoading(){
        isLoading = false
    }
}
