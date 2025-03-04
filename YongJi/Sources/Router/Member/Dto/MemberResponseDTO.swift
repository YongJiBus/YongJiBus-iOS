import Foundation

struct MemberResponseDTO: Decodable {
    let id: Int64
    let email: String
    let name: String
    let username: String
}
