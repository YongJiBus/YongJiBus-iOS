import Foundation
import RxSwift

class AppViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    // Observable property to track the day type
    @Published var isWeekend: Bool = DataManager.weekend {
        didSet {
            DataManager.weekend = isWeekend
        }
    }
    
    @Published var isHolidayAuto: Bool = DataManager.holidayAutomation {
        didSet {
            DataManager.holidayAutomation = isHolidayAuto
        }
    }
    
    public func fetchDayType() {
        DayTypeRepository.shared.getDayType()
            .subscribe(onSuccess: { [weak self] isWeekend in
                self?.isWeekend = isWeekend
            }, onFailure: { error in
                print("Error fetching day type: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
