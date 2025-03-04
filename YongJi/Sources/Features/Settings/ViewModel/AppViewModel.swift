import Foundation
import RxSwift

class AppViewModel: ObservableObject {
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
    
    var isLogin: Bool {
        UserManager.shared.isLoggedIn
    }
    
    var isUser: Bool {
        UserManager.shared.isUser
    }
    
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
