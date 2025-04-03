# 용지버스 채팅 기능 개발 가이드

## 1. 소개

용지버스 앱의 채팅 기능은 MVVM 아키텍처를 기반으로 설계되어 있으며, 실시간 통신을 위해 WebSocket을 사용합니다. 이 문서는 주니어 개발자가 채팅 기능의 구조와 동작 방식을 이해할 수 있도록 도와줍니다.

## 2. 폴더 구조

채팅 기능은 다음과 같은 폴더 구조로 구성되어 있습니다:

```
Chat/
├── Model/              - 데이터 모델 정의
├── View/               - UI 컴포넌트
│   └── Component/      - 재사용 가능한 UI 컴포넌트
├── ViewModel/          - 비즈니스 로직 처리
├── Repository/         - 데이터 액세스 레이어
```

## 3. 주요 모델

### ChatRoom
```swift
struct ChatRoom: Identifiable, Hashable {
    let id: Int64
    let name: String
    let departureTime: String
    let members: Int
    let createdAt: String
    
    // DTO로부터 모델 생성하는 팩토리 메서드
    static func fromDTO(_ dto: ChatRoomResponseDTO) -> ChatRoom {
        // DTO 데이터를 모델로 변환
    }
}
```

### ChatMessage
```swift
struct ChatMessage: Identifiable, Codable, Equatable {
    let messageType: ChatMessageType
    let id: Int64
    let sender: String
    let content: String
    let roomId: Int64
    let timestamp: Date
}

enum ChatMessageType: Codable {
    case enter    // 입장 메시지
    case exit     // 퇴장 메시지
    case message  // 일반 메시지
    case system   // 시스템 메시지
}
```

## 4. 핵심 컴포넌트

### 4.1 Repository

`ChatRepository`는 서버와의 통신을 담당하며, 다음 기능을 제공합니다:

- 모든 채팅방 목록 조회
- 내 채팅방 목록 조회
- 채팅방 생성
- 채팅방 참여
- 채팅 메시지 조회
- FCM 토큰 등록/삭제
- 채팅방 나가기

```swift
func getAllChatRooms() -> Single<[ChatRoomResponseDTO]>
func getMyChatRooms() -> Single<[ChatRoomResponseDTO]>
func createChatRoom(name: String, departureTime: String) -> Single<ChatRoomResponseDTO>
func joinChatRoom(roomId: Int64) -> Single<ChatRoomResponseDTO>
func getChatMessages(roomId: Int64, page: Int = 0, size: Int = 20) -> Single<SliceResponse<ChatMessageResponseDTO>>
func leaveChatRoom(roomId: Int64) -> Single<String>
```

### 4.2 ViewModel

#### ChattingListViewModel
채팅방 목록 관리를 담당합니다:

```swift
class ChattingListViewModel: ObservableObject {
    @Published var myChatRooms: [ChatRoom] = []  // 내 채팅방 목록
    @Published var allChatRooms: [ChatRoom] = [] // 모든 채팅방 목록
    
    func fetchMyChatRooms()    // 내 채팅방 목록 가져오기
    func fetchAllChatRooms()   // 모든 채팅방 목록 가져오기
    func createChatRoom(...)   // 새 채팅방 생성
    func joinChatRoom(...)     // 채팅방 참여
}
```

#### ChatViewModel
채팅방 내 메시지 관리와 WebSocket 통신을 담당합니다:

```swift
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    @Published var shouldScrollToBottom: Bool = false
    // 기타 상태 변수들...
    
    // WebSocket 연결 및 구독 관리
    func connectWebSocket()
    func subscribeToRoom(roomId: Int64)
    func leaveChat()
    
    // 메시지 송수신
    func sendMessage(roomId: Int64, content: String)
    func getChatMessages(roomId: Int64)
    func loadMoreMessages()
    
    // 사용자 신고 기능
    func reportMessage(message: ChatMessage, reason: String)
}
```

### 4.3 View

#### ChattingListView
채팅방 목록을 표시하고 관리하는 화면입니다.

#### ChattingView
개별 채팅방의 대화 화면을 담당합니다:

```swift
struct ChattingView: View {
    let chatRoom: ChatRoom
    @ObservedObject private var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            ChatMessageListView(viewModel: viewModel, chatRoom: chatRoom)
            ChattingTextField
        }
        // 추가 UI 요소 및 이벤트 처리...
    }
    
    // 메시지 전송 기능
    private func sendMessage() {
        viewModel.sendMessage(roomId: chatRoom.id, content: newMessage)
        newMessage = ""
    }
}
```

#### ChatMessageListView 및 ChatMessageListController
UIKit을 SwiftUI에 통합하기 위한 래퍼 컴포넌트입니다. 복잡한 채팅 목록 UI 및 스크롤 처리를 UIKit으로 구현하여 성능을 최적화합니다.

### 4.4 ChatMessageListView와 ChatMessageListController 상세 설명

#### ChatMessageListView
`ChatMessageListView`는 SwiftUI 환경에서 UIKit 컴포넌트를 사용하기 위한 래퍼입니다. `UIViewControllerRepresentable` 프로토콜을 구현하여 `ChatMessageListController`를 SwiftUI 뷰 계층에 통합합니다.

```swift
struct ChatMessageListView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ChatMessageListController
    private let viewModel: ChatViewModel
    private let chatRoom: ChatRoom
    
    init(viewModel: ChatViewModel, chatRoom: ChatRoom) {
        self.viewModel = viewModel
        self.chatRoom = chatRoom
    }
    
    func makeUIViewController(context: Context) -> ChatMessageListController {
        let messageListController = ChatMessageListController(viewModel: viewModel, chatRoom: chatRoom)
        return messageListController
    }
    
    func updateUIViewController(_ uiViewController: ChatMessageListController, context: Context) {
        // UIKit 컨트롤러 업데이트 로직
    }
}
```

주요 기능:
- SwiftUI와 UIKit 간의 브릿지 역할
- `ChatViewModel`과 `ChatRoom` 데이터를 `ChatMessageListController`에 전달
- `UIViewControllerRepresentable` 프로토콜을 준수하여 SwiftUI에서 UIKit 컴포넌트 사용 가능

#### ChatMessageListController
`ChatMessageListController`는 채팅 메시지 목록의 표시와 상호작용을 담당하는 UIKit 기반 컨트롤러입니다. 복잡한 메시지 레이아웃과 스크롤 성능을 최적화하기 위해 `UICollectionView`를 사용합니다.

```swift
final class ChatMessageListController: UIViewController {
    private let chatRoom: ChatRoom
    private let viewModel: ChatViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var lastScrollPosition: Int64?
    
    // UI 컴포넌트와 레이아웃 설정
    // ...
    
    private func setUpChatListener() {
        // Combine을 사용한 데이터 바인딩
        // ...
    }
    
    private func connectToChat() {
        // 채팅 연결 및 메시지 로드
        // ...
    }
}

extension ChatMessageListController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 컬렉션 뷰 데이터 소스 및 델리게이트 메서드
    // ...
}
```

주요 기능:

1. **고성능 메시지 목록 렌더링**
   - `UICollectionViewCompositionalLayout`을 사용하여 최적화된 리스트 레이아웃 구현
   - 컬렉션 뷰의 셀프 사이징 및 동적 높이 조정 지원
   - 키보드 표시/숨김 자동 처리

2. **메시지 로딩 및 스크롤 최적화**
   - 페이지네이션을 통한 효율적인 메시지 로딩 (Pull-to-refresh로 이전 메시지 로드)
   - 스크롤 위치 유지 및 복원 기능 (이전 메시지 로드 시 스크롤 위치 보존)
   - 자동 스크롤 기능 (새 메시지 도착 시)

3. **UI 요소 및 사용자 경험 개선**
   - 새 메시지 알림 배너 표시/숨김 처리
   - 하단으로 빠르게 스크롤할 수 있는 "Pull Down" 버튼
   - 스크롤 위치에 따른 동적 UI 업데이트

4. **메시지 표시 및 상호작용**
   - SwiftUI의 `MessageCell` 컴포넌트를 `UIHostingConfiguration`을 통해 통합
   - 다양한 메시지 타입별 차별화된 UI 표현 (내 메시지/다른 사용자 메시지/시스템 메시지)
   - 메시지 컨텍스트 메뉴를 통한 사용자 신고 기능

5. **반응형 데이터 바인딩**
   - Combine 프레임워크를 사용하여 ViewModel의 변경 사항에 반응
   - 메시지 배열, 스크롤 상태, 로딩 상태 등의 변경에 따른 UI 자동 업데이트
   - 메모리 관리를 위한 `AnyCancellable` 구독 세트 사용

6. **성능 최적화 기법**
   - 메시지 변경 시 디바운스 적용으로 빈번한 UI 업데이트 방지
   - 비동기 작업의 메인 스레드 디스패치 보장
   - 리소스 해제를 위한 적절한 deinit 구현

7. **사용자 상호작용 처리**
   - 스크롤 이벤트 감지 및 UI 상태 업데이트
   - 스크롤 위치에 따른 "Pull Down" 버튼 표시/숨김
   - 새 메시지 배너의 자동 숨김 처리

## 5. 주요 워크플로우

### 5.1 채팅방 생성 및 참여
1. `ChattingListViewModel`에서 `createChatRoom()` 호출
2. 생성 성공 시 `myChatRooms` 목록에 새 채팅방 추가
3. 채팅방 선택 시 `ChattingView`로 이동하여 해당 채팅방 상세 화면 표시

### 5.2 채팅 메시지 교환
1. `ChatViewModel`에서 `subscribeToRoom()`을 통해 WebSocket 연결 설정
2. `ChatViewModel`에서 `getChatMessages()`로 이전 메시지 로드
3. 사용자가 메시지 입력 후 전송 버튼 클릭 시 `sendMessage()` 호출
4. WebSocket을 통해 서버로 메시지 전송
5. 서버에서 WebSocket으로 새 메시지 수신 시 자동으로 `messages` 배열에 추가
6. UI가 반응형으로 업데이트되어 새 메시지 표시

### 5.3 채팅방 나가기
1. `leaveChat()` 메서드 호출
2. 서버에 채팅방 나가기 요청 전송
3. WebSocket 연결 해제 및 리소스 정리

## 6. RxSwift 활용

채팅 기능은 비동기 이벤트 처리를 위해 RxSwift를 활용합니다:

- 네트워크 요청은 `Single<T>` 타입을 반환하여 비동기적으로 처리
- WebSocket 메시지는 `Subject`를 통해 스트림으로 관리
- UI 업데이트는 `MainScheduler.instance`에서 수행
- 메모리 누수 방지를 위해 `disposeBag`으로 구독 관리

## 7. 성능 최적화

- 페이지네이션을 통한 메시지 로딩 (한 번에 30개씩)
- 스크롤 성능 향상을 위해 UIKit 컴포넌트 활용
- 메시지 추가 시 최적화된 업데이트 로직

## 8. 에러 처리

- 모든 네트워크 요청에 에러 처리 로직 포함
- 사용자에게 친절한 에러 메시지 표시
- 연결 실패 시 자동 재연결 시도

## 9. 확장 가능한 부분

- 파일/이미지 전송 기능 추가
- 읽음 확인 기능 구현
- 메시지 검색 기능
- 채팅방 관리자 권한 및 기능

## 10. 참고 사항

- WebSocket 연결은 `WebSocketService` 싱글톤을 통해 관리됨
- 채팅방 참여/퇴장 시 시스템 메시지가 자동으로 생성됨
- 신고 기능은 `MemberReportRepository`를 통해 처리됨