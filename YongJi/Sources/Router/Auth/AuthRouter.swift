import Alamofire
import Foundation

enum AuthRouter {
    case sendAuthEmail(EmailAuthCodeRequestDTO)
    case verifyAuthCode(EmailVerifyRequestDTO)
    case signup(SignupRequestDTO)
    case login(LoginRequestDTO)
    case logout
    case signout
    case checkUsernameExists(String)
}

extension AuthRouter: BaseRouter {
    var baseURL: String {
        APIKey.backendURL + "/auth"
    }
    var method: HTTPMethod {
        switch self {
        case .sendAuthEmail, .verifyAuthCode, .signup, .login:
            return .post
        case .logout, .signout:
            return .delete
        case .checkUsernameExists:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .sendAuthEmail:
            "/email"
        case .verifyAuthCode:
            "/email/verify"
        case .signup:
            "/signup"
        case .login:
            "/login"
        case .logout:
            "/logout"
        case .signout:
            "/signout"
        case .checkUsernameExists(let username):
            "/username/\(username)/exists"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .sendAuthEmail(let dto):
            .body(dto)
        case .verifyAuthCode(let dto):
            .body(dto)
        case .signup(let dto):
            .body(dto)
        case .login(let dto):
            .body(dto)
        case .logout, .signout, .checkUsernameExists:
            .none
        }
    }

    var header: HeaderType {
        switch self {
        case .logout, .signout:
            .auth
        default:
            .basic
        }
    }
} 
