import Alamofire
import Foundation
import RxSwift

final class ChatRepository {
    
    static let shared = ChatRepository()
    
    let service = BaseService()
    
    func getAllChatRooms() -> Single<[ChatRoomResponseDTO]> {
        let router = ChatRouter.getAllChatRooms
        return service.request([ChatRoomResponseDTO].self, router: router)
    }
    
    func getMyChatRooms() -> Single<[ChatRoomResponseDTO]> {
        let router = ChatRouter.getMyChatRooms
        return service.request([ChatRoomResponseDTO].self, router: router)
    }
    
    func createChatRoom(name: String, departureTime: String) -> Single<ChatRoomResponseDTO> {
        let dto = ChatRoomCreateDTO(name: name, departureTime: departureTime)
        let router = ChatRouter.createChatRoom(dto)
        return service.request(ChatRoomResponseDTO.self, router: router)
    }
    
    func joinChatRoom(roomId: Int64) -> Single<ChatRoomResponseDTO> {
        let router = ChatRouter.joinChatRoom(roomId: roomId)
        return service.request(ChatRoomResponseDTO.self, router: router)
    }
    
    func getChatMessages(roomId: Int64, page: Int = 0, size: Int = 20) -> Single<SliceResponse<ChatMessageResponseDTO>> {
        let router = ChatRouter.getChatMessages(roomId: roomId, page: page, size: size)
        return service.request(SliceResponse<ChatMessageResponseDTO>.self, router: router)
    }
    
    func registerFCMToken(token: String) -> Single<String> {
        let router = ChatRouter.registerFCMToken(FCMTokenRegisterDTO(token: token))
        return service.request(String.self, router: router)
    }
    
    func removeFCMToken() -> Single<String> {
        let router = ChatRouter.removeFCMToken
        return service.request(String.self, router: router)
    }
    
    func getChatRoom(roomId: Int64) -> Single<ChatRoomResponseDTO> {
        let router = ChatRouter.getChatRoom(roomId: roomId)
        return service.request(ChatRoomResponseDTO.self, router: router)
    }

    func leaveChatRoom(roomId: Int64) -> Single<String> {
        let router = ChatRouter.leaveChatRoom(roomId: roomId)
        return service.request(String.self, router: router)
    }
}
