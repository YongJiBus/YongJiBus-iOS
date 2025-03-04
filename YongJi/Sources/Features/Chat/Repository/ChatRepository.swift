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
    
    func createChatRoom(name: String, departureTime: String) -> Single<ChatRoomResponseDTO> {
        let dto = ChatRoomCreateDTO(name: name, departureTime: departureTime)
        let router = ChatRouter.createChatRoom(dto)
        return service.request(ChatRoomResponseDTO.self, router: router)
    }
    
    func joinChatRoom(roomId: Int64) -> Single<ChatRoomResponseDTO> {
        let router = ChatRouter.joinChatRoom(roomId: roomId)
        return service.request(ChatRoomResponseDTO.self, router: router)
    }
    
    func getChatMessages(roomId: Int64) -> Single<[ChatMessageResponseDTO]> {
        let router = ChatRouter.getChatMessages(roomId: roomId)
        return service.request([ChatMessageResponseDTO].self, router: router)
    }
} 
