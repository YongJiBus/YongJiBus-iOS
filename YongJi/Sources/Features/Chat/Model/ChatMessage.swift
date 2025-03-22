import Foundation

enum ChatMessageType : Codable {
    case enter
    case exit
    case message
    case system
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value.uppercased() {
        case "ENTER":
            self = .enter
        case "LEAVE", "EXIT":
            self = .exit
        case "MESSAGE", "TALK":
            self = .message
        case "SYSTEM":
            self = .system
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown message type: \(value)"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enter:
            try container.encode("ENTER")
        case .exit:
            try container.encode("LEAVE")
        case .message:
            try container.encode("MESSAGE")
        case .system:
            try container.encode("SYSTEM")
        }
    }
}

struct ChatMessage: Identifiable, Codable, Equatable {
    let messageType: ChatMessageType
    let id : Int64
    let sender: String
    let content: String
    let roomId: Int64
    let timestamp: Date

    
    private enum CodingKeys: String, CodingKey {
        case id
        case sender
        case content
        case roomId
        case timestamp = "createdAt"
        case messageType
    }
}
