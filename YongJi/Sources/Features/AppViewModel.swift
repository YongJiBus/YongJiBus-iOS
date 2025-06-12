import Foundation
import RxSwift

class AppViewModel: ObservableObject {
    public static let shared = AppViewModel()
    
    private let chatRoomRepository = ChatRepository.shared
    private let disposeBag = DisposeBag()
    
    // Observable property to track the day type
    @Published var isHoliday: Bool = DataManager.isHoliday {
        didSet {
            DataManager.isHoliday = isHoliday
        }
    }
    
    @Published var isHolidayAuto: Bool = DataManager.holidayAutomation {
        didSet {
            DataManager.holidayAutomation = isHolidayAuto
        }
    }
    
    @Published var dateInfo : DateInfo = DateInfo(date: .now, dateKind: "평일")

    //푸시 알림 네비게이션
    @Published var shouldNavigateToChat: Bool = false
    @Published var selectedChatRoom: ChatRoom?
    
    var isLogin: Bool {
        UserManager.shared.isLoggedIn
    }
    
    var isUser: Bool {
        UserManager.shared.isUser
    }
    
    init() {
        // 앱이 시작될 때 앱 실행 이벤트를 기록
        AnalyticsManager.shared.logAppOpen()
    }
}

extension AppViewModel {

    //푸시 알림 네비게이션
    public func navigateToChatRoom(roomId: Int64) {
        print("AppViewModel: NavtigateToChatRoom")
        shouldNavigateToChat = true
        chatRoomRepository.getChatRoom(roomId: roomId)
            .subscribe(onSuccess: { [weak self] dto in
                self?.selectedChatRoom = ChatRoom(id: dto.id, name: dto.name, departureTime: dto.departureTime, members: dto.userCount, createdAt: dto.createdAt)
            }, onFailure: { [weak self] error in
                self?.selectedChatRoom = nil
            })
            .disposed(by: disposeBag)
    }

    //평일 / 주말 설정
    public func fetchDayType() {
        DayTypeRepository.shared.getDayType()
            .subscribe(onSuccess: { [weak self] dto in
                self?.isHoliday = dto.isHoliday
                self?.dateInfo = dto.toEntity()
            }, onFailure: { [weak self] error in
                self?.isHoliday = false
            })
            .disposed(by: disposeBag)
    }
}
