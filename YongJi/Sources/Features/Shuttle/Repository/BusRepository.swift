//
//  BusRepository.swift
//  YongJiBus
//
//  Created by 김도경 on 4/29/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

class BusRepository {
    static let shared = BusRepository()

    private let service = BaseService()

    func fetchBusTime(busNumber: BusNumber) -> Single<BusTime> {
        let router = BusRouter.getBusArrivalTime(routeId: busNumber.route)
        return service.requestOpenAPI(BusTime.self, router: router)
    }
}
