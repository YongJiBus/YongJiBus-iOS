import Foundation

struct ChatRoom : Identifiable{
    let id : Int
    let name: String
    let time: String
    var members: Int
    let maxMembers: Int = 4
    
    var isFull: Bool {
        return members >= maxMembers
    }
} 
