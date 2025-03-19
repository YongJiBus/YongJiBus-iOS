import SwiftUI
import RxSwift

/// 테스트 및 프리뷰를 위한 Mock ViewModel
class MockChattingListViewModel: ChattingListViewModel {
    
    override init() {
        super.init()
        // 초기화 직후 Mock 데이터 로드
        generateMockData()
    }
    
    // Mock 데이터 생성
    private func generateMockData() {
        // 날짜 포맷 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 현재 날짜와 시간 문자열
        let now = Date()
        let currentDateStr = dateFormatter.string(from: now)
        let oneHourAgo = dateFormatter.string(from: now.addingTimeInterval(-3600))
        let twoHoursAgo = dateFormatter.string(from: now.addingTimeInterval(-7200))
        let threeHoursAgo = dateFormatter.string(from: now.addingTimeInterval(-10800))
        let fourHoursAgo = dateFormatter.string(from: now.addingTimeInterval(-14400))
        
        // 모든 채팅방 목록 샘플 데이터
        allChatRooms = [
            ChatRoom(id: 1, name: "기흥역에서 명진당", departureTime: "08:30", members: 3, createdAt: currentDateStr),
            ChatRoom(id: 2, name: "명진당에서 자연과학관", departureTime: "10:15", members: 2, createdAt: oneHourAgo),
            ChatRoom(id: 3, name: "명진당에서 기흥역", departureTime: "12:00", members: 5, createdAt: twoHoursAgo),
            ChatRoom(id: 4, name: "자연과학관에서 제2공학관", departureTime: "14:30", members: 1, createdAt: threeHoursAgo),
            ChatRoom(id: 5, name: "제2공학관에서 기흥역", departureTime: "16:45", members: 4, createdAt: fourHoursAgo)
        ]
        
        // 내 채팅방 목록 샘플 데이터 (전체 중 일부만 포함)
        myChatRooms = [
//            allChatRooms[0],
//            allChatRooms[2]
        ]
    }
    
    // 네트워크 호출 없이 Mock 데이터 반환
//    override func fetchMyChatRooms() {
//        // 이미 초기화 시점에 데이터가 설정되어 있으므로 별도 작업 불필요
//        // 필요시 여기서 데이터 갱신 가능
//    }
    
    override func fetchAllChatRooms() {
        // 이미 초기화 시점에 데이터가 설정되어 있으므로 별도 작업 불필요
        // 필요시 여기서 데이터 갱신 가능
    }
    
    
    // 채팅방 생성 Mock 메소드
    override func createChatRoom(name: String, departureTime: String, completion: @escaping (Result<ChatRoom, Error>) -> Void) {
        // 날짜 포맷 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateStr = dateFormatter.string(from: Date())
        
        // 새 채팅방 생성 시뮬레이션
        let newChatRoom = ChatRoom(
            id: Int64(allChatRooms.count + 1),
            name: name, 
            departureTime: departureTime,
            members: 1,
            createdAt: currentDateStr
        )
        
        // 목록에 추가
        allChatRooms.insert(newChatRoom, at: 0)
        myChatRooms.insert(newChatRoom, at: 0)
        
        // 지연 시뮬레이션 후 완료 콜백
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(newChatRoom))
        }
    }
    
    // 채팅방 입장 Mock 메소드
    override func joinChatRoom(roomId: Int64, completion: @escaping (Result<ChatRoom, Error>) -> Void) {
        // 채팅방 찾기
        if let chatRoom = allChatRooms.first(where: { $0.id == roomId }) {
            // 이미 내 채팅방에 있는지 확인
            if !myChatRooms.contains(where: { $0.id == roomId }) {
                // 내 채팅방에 추가
                myChatRooms.insert(chatRoom, at: 0)
            }
            
            // 성공 콜백
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                completion(.success(chatRoom))
            }
        } else {
            // 에러 시뮬레이션
            struct MockError: Error, LocalizedError {
                var errorDescription: String? { return "채팅방을 찾을 수 없습니다" }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                completion(.failure(MockError()))
            }
        }
    }
}

//// SwiftUI 프리뷰용 ChattingListView 확장
//extension ChattingListView {
//    static var mockPreview: some View {
//        let view = ChattingListView()
//        
//        // ViewModel을 Mock으로 교체
//        let mockViewModel = MockChattingListViewModel()
//        view.viewModel = mockViewModel
//        
//        // AppViewModel 제공
//        let appViewModel = AppViewModel()
//        // 테스트를 위해 로그인 상태로 설정
//        // (여기서는 직접 속성에 접근할 수 없으므로 실제 앱에서는 다른 방식으로 구현 필요)
//        
//        return view
//            .environmentObject(appViewModel)
//    }
//} 
