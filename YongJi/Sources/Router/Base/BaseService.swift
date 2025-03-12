//
//  BaseService.swift
//  YongJiBus
//
//  Created by bryan on 11/16/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

protocol NetworkService {
    func request<T: Decodable>(_ responseDTO : T.Type, router: BaseRouter) -> Single<T>
}

public class BaseService : NetworkService {
    
    let AFManager: Session = {
        var session = AF
        let configuration = URLSessionConfiguration.af.default
        let eventLogger = APILogger()
        session = Session(configuration: configuration, eventMonitors: [eventLogger])
        return session
    }()
    
    public init(){}
    
    func request<T:Decodable>( _ responseDTO : T.Type, router: BaseRouter) -> Single<T> {
        return Single<T>.create{ single in
            self.AFManager.request(router)
                .validate(statusCode: 200...299)
                .responseDecodable(of: ApiResponse<T>.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(result.data))
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                let errorResponse = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                                single(.failure(APIError.serverError(errorResponse)))
                            } catch {
                                single(.failure(APIError.decodingError(error))) // 파싱 실패
                            }
                        } else {
                            single(.failure(APIError.networkError(error))) // 네트워크 에러
                        }
                    }
            }
            return Disposables.create {
            }
        }
    }
}



final class MyRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let urlRequest = urlRequest
        
        //urlRequest.setValue("1", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}
