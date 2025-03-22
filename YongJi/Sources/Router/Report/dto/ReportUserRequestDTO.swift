import Foundation

struct ReportUserRequestDTO: Encodable {
    let reason: String
    let roomId: Int64
    let reportedUserName: String
} 
