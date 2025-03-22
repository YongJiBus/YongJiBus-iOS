import Alamofire
import Foundation

enum ChatRouter {
    case getAllChatRooms
    case getMyChatRooms
    case createChatRoom(ChatRoomCreateDTO)
    case joinChatRoom(roomId: Int64)
    case getChatMessages(roomId: Int64, page: Int = 0, size: Int = 20)
    case getChatRoom(roomId: Int64)
    case leaveChatRoom(roomId: Int64)
    case registerFCMToken(FCMTokenRegisterDTO)
    case removeFCMToken
}

extension ChatRouter: BaseRouter {
    var baseURL: String {
        APIKey.backendURL + "/chat"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllChatRooms, .getMyChatRooms, .getChatMessages, .getChatRoom:
            return .get
        case .createChatRoom, .joinChatRoom, .registerFCMToken, .removeFCMToken:
            return .post
        case .leaveChatRoom:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getAllChatRooms:
            return "/rooms"
        case .getMyChatRooms:
            return "/rooms/my"
        case .createChatRoom:
            return "/rooms"
        case .joinChatRoom(let roomId):
            return "/rooms/\(roomId)"
        case .getChatMessages(let roomId, _, _):
            return "/rooms/\(roomId)/messages"
        case .registerFCMToken:
            return "/fcm-token"
        case .removeFCMToken:
            return "/fcm-token/remove"
        case .getChatRoom(let roomId):
            return "/rooms/\(roomId)"
        case .leaveChatRoom(let roomId):
            return "/rooms/\(roomId)/leave"
        }
    }
    
    var parameter: RequestParams {
        switch self {
        case .getAllChatRooms, .getMyChatRooms:
            return .none
        case .getChatMessages(_, let page, let size):
            return .query(ChatPageRequestDTO(page: page, size: size))
        case .createChatRoom(let dto):
            return .body(dto)
        case .joinChatRoom:
            return .none
        case .registerFCMToken(let dto):
            return .body(dto)
        case .removeFCMToken:
            return .none
        case .getChatRoom:
            return .none
        case .leaveChatRoom:
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
