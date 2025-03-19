import Foundation

struct ChatMessageSendDTO : Codable {
    let messageType : ChatMessageType
    let sender : String
    let content : String
    let roomId : Int64
}
