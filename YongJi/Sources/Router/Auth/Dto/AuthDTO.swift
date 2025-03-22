import Foundation

struct EmailAuthCodeRequestDTO: Encodable {
    let email: String
}

struct EmailVerifyRequestDTO: Encodable {
    let email: String
    let authCode: String
}

struct SignupRequestDTO: Encodable {
    let email: String
    let password: String
    let name: String
    let username: String
}

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct UsernameExistsResponseDTO: Decodable {
    let exists: Bool
} 