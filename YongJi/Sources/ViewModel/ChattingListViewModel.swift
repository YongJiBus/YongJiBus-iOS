import SwiftUI

// ViewModel to manage chat rooms
class ChattingListViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = [
        ChatRoom(id: 1, name: "Chat Room 1", time: "10:00", members: 3),
        ChatRoom(id: 2, name: "Chat Room 2", time: "11:00", members: 2),
        // Add more chat rooms as needed
    ]
} 
