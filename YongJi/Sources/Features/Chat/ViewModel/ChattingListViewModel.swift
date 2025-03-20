import SwiftUI
import RxSwift

// ViewModel to manage chat rooms
class ChattingListViewModel: ObservableObject {
    @Published var myChatRooms: [ChatRoom] = []
    @Published var allChatRooms: [ChatRoom] = []
    @Published var errorMessage: String?
    
    private let chatRepository = ChatRepository.shared
    private let disposeBag = DisposeBag()
    
    // 내 채팅방만 가져오는 메서드
    func fetchMyChatRooms() {
        chatRepository.getMyChatRooms()
            .subscribe(onSuccess: { [weak self] chatRoomDTOs in
                guard let self = self else { return }
                
                let chatRooms = chatRoomDTOs.map { ChatRoom.fromDTO($0) }
                
                DispatchQueue.main.async {
                    self.myChatRooms = chatRooms
                }
            }, onFailure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.errorMessage = "내 채팅방 목록을 불러오는데 실패했습니다."
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 모든 채팅방 가져오는 메서드
    func fetchAllChatRooms() {
        chatRepository.getAllChatRooms()
            .subscribe(onSuccess: { [weak self] chatRoomDTOs in
                guard let self = self else { return }
                
                let chatRooms = chatRoomDTOs.map { ChatRoom.fromDTO($0) }
                
                DispatchQueue.main.async {
                    self.allChatRooms = chatRooms
                }
            }, onFailure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.errorMessage = "채팅방 목록을 불러오는데 실패했습니다."
                }
            })
            .disposed(by: disposeBag)
    }
    
    func createChatRoom(name: String, departureTime: String, completion: @escaping (Result<ChatRoom, Error>) -> Void) {
        chatRepository.createChatRoom(name: name, departureTime: departureTime)
            .subscribe(onSuccess: { chatRoomDTO in
                let chatRoom = ChatRoom.fromDTO(chatRoomDTO)
                
                DispatchQueue.main.async {
                    completion(.success(chatRoom))
                }
            }, onFailure: { error in
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    func joinChatRoom(roomId: Int64, completion: @escaping (Result<ChatRoom, Error>) -> Void) {
        chatRepository.joinChatRoom(roomId: roomId)
            .subscribe(onSuccess: { chatRoomDTO in
                let chatRoom = ChatRoom.fromDTO(chatRoomDTO)
                
                DispatchQueue.main.async {
                    completion(.success(chatRoom))
                }
            }, onFailure: { error in
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            })
            .disposed(by: disposeBag)
    }
}
