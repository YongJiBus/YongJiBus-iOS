import Foundation

struct ChatRoomResponseDTO: Decodable {
    let id: Int64
    let name: String
    let departureTime: String
    let userCount: Int
    let createdAt: String
} 
