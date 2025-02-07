import Alamofire
import Foundation

enum ArrivalTimeRouter {
    case saveArrivalTime(SaveArrivalTimeRequestDTO)
    case getArrivalTimes(date: String, busId: Int)
    case getAllArrivalTimes(date : String)
}

extension ArrivalTimeRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .saveArrivalTime:
            .post
        case .getArrivalTimes:
            .get
        case .getAllArrivalTimes:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .saveArrivalTime:
            "/arrivaltime/save"
        case let .getArrivalTimes(date, busId):
            "/arrivaltime/\(date)/\(busId)"
        case let .getAllArrivalTimes(date):
            "/arrivaltime/\(date)"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .saveArrivalTime(let request):
            .body(request)
        case .getArrivalTimes, .getAllArrivalTimes:
                .none
        }
    }
}
