import Alamofire
import Foundation
import RxSwift

final class ArrivalTimeRepository {
    
    static let shared = ArrivalTimeRepository()
    
    let service = BaseService()
    
    func saveArrivalTime(requestDTO: SaveArrivalTimeRequestDTO) -> Single<Dictionary<String,String>> {
        let router = ArrivalTimeRouter.saveArrivalTime(requestDTO)
        print(requestDTO)
        return service.request(Dictionary<String,String>.self, router: router)
    }
    
    func getArrivalTimes(busId: Int) -> Single<[ArrivalTimeResponseDTO]> {
        let dateString = DateFormatter.yearMonthDay.string(from: .now)
        let router = ArrivalTimeRouter.getArrivalTimes(date: dateString, busId: busId)
        return service.request([ArrivalTimeResponseDTO].self, router: router)
    }
    
    func getAllArrivalTimes() -> Single<[ArrivalTimeListReponseDTO]> {
        let date = DateFormatter.yearMonthDay.string(from: .now)
        let router = ArrivalTimeRouter.getAllArrivalTimes(date: date)
        return service.request([ArrivalTimeListReponseDTO].self, router: router)
    }
}
