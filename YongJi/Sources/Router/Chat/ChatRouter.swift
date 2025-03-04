import Alamofire
import Foundation

enum ChatRouter {
    case getAllChatRooms
    case createChatRoom(ChatRoomCreateDTO)
    case joinChatRoom(roomId: Int64)
    case getChatMessages(roomId: Int64)
}

extension ChatRouter: BaseRouter {
    var baseURL: String {
        APIKey.backendURL + "/chat"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllChatRooms, .getChatMessages:
            return .get
        case .createChatRoom, .joinChatRoom:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getAllChatRooms:
            return "/rooms"
        case .createChatRoom:
            return "/rooms"
        case .joinChatRoom(let roomId):
            return "/rooms/\(roomId)"
        case .getChatMessages(let roomId):
            return "/rooms/\(roomId)/messages"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .getAllChatRooms, .getChatMessages:
            return .none
        case .createChatRoom(let dto):
            return .body(dto)
        case .joinChatRoom:
            return .none
        }
    }
    
    var header: HeaderType {
        switch self {
        default:
                .auth
        }
    }
}
