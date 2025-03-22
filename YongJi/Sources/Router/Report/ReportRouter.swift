import Alamofire
import Foundation

enum ReportRouter {
    case reportUser(ReportUserRequestDTO)
}

extension ReportRouter: BaseRouter {
    var baseURL: String {
        APIKey.backendURL + "/report"
    }
    
    var method: HTTPMethod {
        switch self {
        case .reportUser:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .reportUser:
            return "/user"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .reportUser(let dto):
            return .body(dto)
        }
    }
    
    var header: HeaderType {
        switch self {
        default:
            return .auth
        }
    }
} 