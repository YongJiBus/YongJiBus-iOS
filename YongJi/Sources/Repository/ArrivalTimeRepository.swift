import Alamofire
import Foundation
import RxSwift

final class ArrivalTimeRepository {
    
    static let shared = ArrivalTimeRepository()
    
    let service = BaseService()
    
    func saveArrivalTime(busId: Int, date: Date, arrivalTime: Date) -> Single<String> {
        let requestDTO = SaveArrivalTimeRequestDTO(busId: busId, 
                                                 date: date, 
                                                 arrivalTime: arrivalTime)
        let router = ArrivalTimeRouter.saveArrivalTime(requestDTO)
        return service.request(String.self, router: router)
    }
    
    func getArrivalTimes(busId: Int, date: Date) -> Single<[ArrivalTimeResponseDTO]> {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let router = ArrivalTimeRouter.getArrivalTimes(date: dateString, busId: busId)
        return service.request([ArrivalTimeResponseDTO].self, router: router)
    }
} 