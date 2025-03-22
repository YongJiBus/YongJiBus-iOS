import Alamofire
import Foundation
import RxSwift

final class MemberRepository {
    static let shared = MemberRepository()

    let service = BaseService()
    
    func getCurrentMember() -> Single<MemberResponseDTO> {
        let router = MemberRouter.getCurrentMember
        return service.request(MemberResponseDTO.self, router: router)
    }
}   
