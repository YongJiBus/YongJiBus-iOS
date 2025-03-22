import Alamofire
import Foundation
import RxSwift

final class MemberReportRepository {
    
    static let shared = MemberReportRepository()
    
    let service = BaseService()
    
    func reportUser(reason: String, roomId: Int64, reportedUserName: String) -> Single<String> {
        let dto = ReportUserRequestDTO(
            reason: reason,
            roomId: roomId,
            reportedUserName: reportedUserName
        )
        let router = ReportRouter.reportUser(dto)
        return service.request(String.self, router: router)
    }
} 
