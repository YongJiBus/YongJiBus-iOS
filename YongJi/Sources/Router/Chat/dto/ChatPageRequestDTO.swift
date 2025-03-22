import Foundation

struct ChatPageRequestDTO: Queriable {
    let page: Int
    let size: Int
    
    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
    }
} 