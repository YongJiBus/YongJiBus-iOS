import Foundation

struct ChatRoom: Identifiable, Hashable {
    let id: Int64
    let name: String
    let departureTime: String
    let members: Int
    let createdAt: String
    
    init(id: Int64, name: String, departureTime: String, members: Int, createdAt: String = "") {
        self.id = id
        self.name = name
        self.departureTime = departureTime
        self.members = members
        self.createdAt = createdAt
    }
    
    static func fromDTO(_ dto: ChatRoomResponseDTO) -> ChatRoom {
        let startIndex = dto.departureTime.startIndex
        let lastIndex = dto.departureTime.index(startIndex, offsetBy: 5)
        let trimmedString = dto.departureTime[startIndex..<lastIndex]
        return ChatRoom(
            id: dto.id,
            name: dto.name,
            departureTime: String(trimmedString),
            members: dto.userCount,
            createdAt: dto.createdAt
        )
    }
} 
