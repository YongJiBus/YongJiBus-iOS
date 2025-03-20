import Alamofire
import Foundation
import RxSwift

final class AuthRepository {
    
    static let shared = AuthRepository()
    
    let service = BaseService()
    
    func sendAuthEmail(email: String) -> Single<String> {
        let dto = EmailAuthCodeRequestDTO(email: email)
        let router = AuthRouter.sendAuthEmail(dto)
        return service.request(String.self, router: router)
    }
    
    func verifyAuthCode(email: String, code: String) -> Single<String> {
        let dto = EmailVerifyRequestDTO(email: email, authCode: code)
        let router = AuthRouter.verifyAuthCode(dto)
        return service.request(String.self, router: router)
    }
    
    func signup(email: String, password: String, name: String, username: String) -> Single<AuthTokenDTO> {
        let dto = SignupRequestDTO(
            email: email,
            password: password,
            name: name,
            username: username
        )
        let router = AuthRouter.signup(dto)
        return service.request(AuthTokenDTO.self, router: router)
    }
    
    func login(email: String, password: String) -> Single<AuthTokenDTO> {
        let dto = LoginRequestDTO(email: email, password: password)
        let router = AuthRouter.login(dto)
        return service.request(AuthTokenDTO.self, router: router)
    }
    
    func logout() -> Single<String> {
        let router = AuthRouter.logout
        return service.request(String.self, router: router)
    }
    
    func signout() -> Single<String> {
        let router = AuthRouter.signout
        return service.request(String.self, router: router)
    }
    
    func checkUsernameExists(username: String) -> Single<UsernameExistsResponseDTO> {
        let router = AuthRouter.checkUsernameExists(username)
        return service.request(UsernameExistsResponseDTO.self, router: router)
    }
} 
