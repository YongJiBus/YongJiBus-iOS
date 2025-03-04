import Foundation

struct ChatMessage: Identifiable, Codable {
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
    }
}
