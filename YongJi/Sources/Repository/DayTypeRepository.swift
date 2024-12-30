//
//  DayTypeRepository.swift
//  YongJiBus
//
//  Created by bryan on 11/16/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

final class DayTypeRepository {
    
    static let shared = DayTypeRepository()
    
    let service = BaseService()
    
    func getDayType() -> Single<Bool>{
        
        let date = Date()
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"
        
        let dto = GetDayTypeDTO(value: formatter.string(from: date))
        let router = DayTypeRouter.getDayType(dto)
        return service.request(Bool.self, router: router)
    }
}
