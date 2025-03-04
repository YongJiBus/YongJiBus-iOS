import Alamofire
import Foundation

enum MemberRouter {
    case getCurrentMember
}

extension MemberRouter: BaseRouter {
    var baseURL: String {
        APIKey.backendURL + "/member"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentMember:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getCurrentMember:
            return "/me"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .getCurrentMember:
            return .none
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getCurrentMember:
            return .auth
        }
    }
} 