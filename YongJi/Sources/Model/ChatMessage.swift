import Foundation

struct ChatMessage: Identifiable {
    let id : Int
    let sender: String
    let message: String
    let timestamp: Date
} 