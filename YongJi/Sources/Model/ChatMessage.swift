import Foundation

struct ChatMessage: Identifiable, Codable {
    let id : Int
    let sender: String
    let message: String
    let timestamp: Date
} 
