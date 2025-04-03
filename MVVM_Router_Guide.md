# 용지버스 앱의 MVVM 구조와 Router 활용 가이드

## 1. MVVM 아키텍처 개요

MVVM(Model-View-ViewModel) 아키텍처는 용지버스 앱의 기본 설계 패턴으로, UI 로직과 비즈니스 로직을 명확하게 분리하여 코드의 유지보수성과 테스트 용이성을 높입니다.

### 1.1 MVVM의 주요 컴포넌트

#### Model
- 데이터 구조와 비즈니스 로직을 담당
- API 응답 데이터를 앱 내부에서 사용하기 적합한 형태로 변환
- 예시: `ChatRoom`, `ChatMessage` 등

#### View
- 사용자 인터페이스 표현 담당
- SwiftUI로 구현된 화면 컴포넌트
- ViewModel의 상태 변화를 관찰하여 UI 업데이트
- 예시: `ChattingView`, `ChatMessageListView` 등

#### ViewModel
- View와 Model 사이의 중재자 역할
- 비즈니스 로직 처리 및 데이터 가공
- `@Published` 프로퍼티를 통해 상태 변화 알림
- 예시: `ChatViewModel`, `ChattingListViewModel` 등

### 1.2 MVVM 데이터 흐름

1. **View → ViewModel**: 사용자 입력이 View를 통해 ViewModel로 전달
2. **ViewModel → Repository**: ViewModel이 Repository를 통해 데이터 요청
3. **Repository → API**: Router를 사용하여 서버 통신
4. **API → Repository → ViewModel**: 응답 데이터가 Repository를 통해 ViewModel로 전달
5. **ViewModel → View**: `@Published` 프로퍼티 변경으로 View 자동 업데이트

## 2. Router 패턴 활용

Router 패턴은 네트워크 요청을 추상화하여 코드의 가독성과 유지보수성을 높이는 방법입니다. 용지버스 앱에서는 Alamofire와 함께 Router 패턴을 사용하여 API 호출을 관리합니다.

### 2.1 Router 구조

#### BaseRouter 프로토콜
```swift
protocol BaseRouter: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: RequestParams { get }
    var header: HeaderType { get }
}
```

#### HeaderType 열거형
```swift
enum HeaderType {
    case basic // 헤더에 아무 정보가 없는거
    case auth // 헤더에 JWT 토큰이 있는거
}
```

#### RequestParams 열거형
```swift
enum RequestParams {
    case query(_ parameter: Queriable)
    case body(_ parameter: Encodable)
    case none
}
```

### 2.2 Router 구현 예시 (ChatRouter)

```swift
enum ChatRouter {
    case getAllChatRooms
    case getMyChatRooms
    case createChatRoom(ChatRoomCreateDTO)
    case joinChatRoom(roomId: Int64)
    case getChatMessages(roomId: Int64, page: Int = 0, size: Int = 20)
    // 기타 케이스들...
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
        // 기타 경로들...
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
        // 기타 파라미터 처리...
        }
    }
    
    var header: HeaderType {
        return .auth
    }
}
```

### 2.3 BaseService를 통한 네트워크 요청

```swift
class BaseService: NetworkService {
    func request<T: Decodable>(_ responseDTO: T.Type, router: BaseRouter) -> Single<T> {
        // 실제 네트워크 요청 구현
        // RxSwift의 Single 타입 반환
    }
}
```

## 3. Repository 패턴

Repository 패턴은 데이터 액세스 로직을 캡슐화하여 ViewModel이 직접 네트워크 통신에 의존하지 않도록 합니다.

### 3.1 Repository 구현 예시 (ChatRepository)

```swift
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
    
    // 기타 메서드들...
}
```

## 4. MVVM과 Router 통합하기

### 4.1 ViewModel에서 Repository 활용

```swift
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var errorMessage: String? = nil
    
    private let chatRepository = ChatRepository.shared
    private let disposeBag = DisposeBag()
    
    func getChatMessages(roomId: Int64) {
        chatRepository.getChatMessages(roomId: roomId, page: currentPage, size: pageSize)
            .subscribe(onSuccess: { [weak self] sliceResponse in
                let newMessages = sliceResponse.content.map{ $0.toModel() }
                self?.messages = newMessages
                // 상태 업데이트...
            }, onFailure: { error in
                self.errorMessage = "메시지를 불러오는 중 오류가 발생했습니다: \(error.localizedDescription)"
                self.showError = true
            })
            .disposed(by: disposeBag)
    }
    
    // 기타 메서드들...
}
```

### 4.2 View에서 ViewModel 활용

```swift
struct ChattingView: View {
    let chatRoom: ChatRoom
    @ObservedObject private var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            ChatMessageListView(viewModel: viewModel, chatRoom: chatRoom)
            ChattingTextField
        }
        // UI 구성 및 이벤트 처리...
    }
}
```

## 5. 구현 가이드라인

### 5.1 새로운 기능 구현 순서

1. **Model 정의**: 데이터 구조와 DTO 모델 정의
2. **Router 확장**: API 엔드포인트에 맞는 Router 케이스 추가
3. **Repository 구현**: Router를 사용하여 데이터 액세스 로직 구현
4. **ViewModel 구현**: Repository를 사용하여 비즈니스 로직 처리
5. **View 구현**: ViewModel을 구독하여 UI 표현

### 5.2 RxSwift 활용

- 네트워크 요청에는 `Single<T>` 타입 사용
- 이벤트 스트림에는 `Subject` 활용
- UI 업데이트는 `MainScheduler.instance`에서 수행
- 메모리 누수 방지를 위해 `disposeBag` 사용

### 5.3 MVVM 모범 사례

- ViewModel은 View에 독립적으로 설계
- View는 상태를 직접 변경하지 않고 ViewModel 메서드 호출
- Model은 순수한 데이터 구조로 유지
- DTO를 앱 내부 Model로 변환하는 메서드 제공

## 6. 확장 및 테스트

### 6.1 ViewModel 테스트

MVVM 아키텍처는 ViewModel 단위 테스트를 용이하게 합니다:

```swift
func testGetChatMessages() {
    // given
    let mockRepository = MockChatRepository()
    let viewModel = ChatViewModel(chatRepository: mockRepository)
    
    // when
    viewModel.getChatMessages(roomId: 1)
    
    // then
    XCTAssertEqual(viewModel.messages.count, expectedCount)
}
```

### 6.2 Mock 구현

개발 및 테스트 목적으로 Mock 구현을 활용할 수 있습니다:

```swift
class MockChattingListViewModel: ChattingListViewModel {
    override func fetchAllChatRooms() {
        // 테스트용 데이터로 채우기
        self.allChatRooms = [
            ChatRoom(id: 1, name: "테스트 채팅방", departureTime: "12:30", members: 3)
        ]
    }
}
```

## 7. 결론

MVVM 아키텍처와 Router 패턴을 함께 사용하면 다음과 같은 이점이 있습니다:

- **코드 분리**: UI 로직과 비즈니스 로직의 명확한 분리
- **유지보수성**: 각 컴포넌트의 책임이 명확하여 코드 수정이 용이
- **테스트 용이성**: ViewModel과 Repository의 독립적인 테스트 가능
- **확장성**: 새로운 기능 추가가 기존 코드에 영향을 최소화 