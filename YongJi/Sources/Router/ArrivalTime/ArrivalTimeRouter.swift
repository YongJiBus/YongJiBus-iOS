import Alamofire
import Foundation

enum ArrivalTimeRouter {
    case saveArrivalTime(SaveArrivalTimeRequestDTO)
    case getArrivalTimes(date: String, busId: Int)
}

extension ArrivalTimeRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .saveArrivalTime:
            .post
        case .getArrivalTimes:
            .get
        }
    }
    
    var path: String {
        switch self {
        case .saveArrivalTime:
            "/arrivaltime/save"
        case let .getArrivalTimes(date, busId):
            "/arrivaltime/\(date)/\(busId)"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .saveArrivalTime(let request):
            .body(request)
        case .getArrivalTimes:
            .none
        }
    }
}
