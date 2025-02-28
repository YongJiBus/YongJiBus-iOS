import Alamofire
import Foundation

enum AuthRouter {
    case sendAuthEmail(EmailAuthCodeRequestDTO)
    case verifyAuthCode(EmailVerifyRequestDTO)
    case signup(SignupRequestDTO)
    case login(LoginRequestDTO)
}

extension AuthRouter: BaseRouter {
    var baseURL: String {
        APIKey.backendURL + "/auth"
    }
    var method: HTTPMethod {
        switch self {
        case .sendAuthEmail, .verifyAuthCode, .signup, .login:
            return .post
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
        }
    }
} 
