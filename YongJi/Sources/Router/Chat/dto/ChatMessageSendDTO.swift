import Foundation

struct ChatMessageSendDTO : Codable {
    let sender : String
    let content : String
    let roomId : Int64
    let createdAt : String
}
