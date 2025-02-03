import Alamofire
import Foundation
import RxSwift

final class ArrivalTimeRepository {
    
    static let shared = ArrivalTimeRepository()
    
    let service = BaseService()
    
    func saveArrivalTime(requestDTO: SaveArrivalTimeRequestDTO) {
        let router = ArrivalTimeRouter.saveArrivalTime(requestDTO)
        print(requestDTO)
        service.request(String.self, router: router)
            .subscribe { message in
                print(message)
            } onFailure: { error in
                print(error)
            }
            .dispose()

    }
    
    func getArrivalTimes(busId: Int) -> Single<[ArrivalTimeResponseDTO]> {
        let dateString = DateFormatter.yearMonthDay.string(from: .now)
        let router = ArrivalTimeRouter.getArrivalTimes(date: dateString, busId: busId)
        return service.request([ArrivalTimeResponseDTO].self, router: router)
    }
} 
