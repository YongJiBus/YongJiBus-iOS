import SwiftUI
import RxSwift

// ViewModel to manage chat rooms
class ChattingListViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let chatRepository = ChatRepository.shared
    private let disposeBag = DisposeBag()
    
    func fetchChatRooms() {
        isLoading = true
        errorMessage = nil
        
        chatRepository.getAllChatRooms()
            .subscribe(onSuccess: { [weak self] chatRoomDTOs in
                guard let self = self else { return }
                
                let rooms = chatRoomDTOs.map { ChatRoom.fromDTO($0) }
                
                DispatchQueue.main.async {
                    self.chatRooms = rooms
                    self.isLoading = false
                }
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                let error = error as? APIError
                let errorMsg = error?.parseError()
                
                DispatchQueue.main.async {
                    self.errorMessage = errorMsg
                    self.isLoading = false
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
