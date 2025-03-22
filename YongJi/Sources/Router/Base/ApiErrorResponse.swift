//
//  ApiErrorResponse.swift
//  YongJiBus
//
//  Created by 김도경 on 3/4/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

enum APIError: Error {
    case serverError(ApiErrorResponse) // 서버에서 내려준 에러 응답
    case decodingError(Error) // 에러 응답 파싱 실패
    case networkError(Error) // Alamofire 자체 에러
}

struct ApiErrorResponse :Decodable {
    let status: Int
    let data: String
}


extension APIError {
    func parseError() -> String {
        switch self {
        case APIError.serverError(let errorResponse):
            "🚨 서버 오류: \(errorResponse.status) - \(errorResponse.data)"
        case APIError.decodingError(_):
            "📛 디코딩 오류: 다시시도해주세요"
        case APIError.networkError(_):
            "🌐 네트워크 오류: 다시시도해주세요"
        }
    }
}
