import Alamofire
import Foundation

enum ChatRouter {
    case getAllChatRooms
    case createChatRoom(ChatRoomCreateDTO)
    case joinChatRoom(roomId: Int64)
    case getChatMessages(roomId: Int64)
    case registerFCMToken(FCMTokenRegisterDTO)
    case removeFCMToken
}

extension ChatRouter: BaseRouter {
    var baseURL: String {
        APIKey.backendURL + "/chat"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllChatRooms, .getChatMessages:
            return .get
        case .createChatRoom, .joinChatRoom, .registerFCMToken, .removeFCMToken:
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
        case .registerFCMToken:
            return "/fcm-token"
        case .removeFCMToken:
            return "/fcm-token/remove"
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
        case .registerFCMToken(let dto):
            return .body(dto)
        case .removeFCMToken:
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