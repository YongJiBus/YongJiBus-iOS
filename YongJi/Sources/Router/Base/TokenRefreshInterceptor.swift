import Alamofire
import Foundation

final class TokenRefreshInterceptor: RequestInterceptor {
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // 여러 요청이 한번에 이루어질 때 리프레시 토큰 발급 요청을 한번만 처리하기 위한 LOCK
        lock.lock()
        defer { lock.unlock() }
        
        // Check if the error is a 401 Unauthorized
        guard let response = request.response, response.statusCode == 401 else {
            //print("doNotRetry")
            completion(.doNotRetry)
            return
        }
        // 현재 재발급 요청이 이루어지고 있을 때, 다른 작업들을 큐에 넣어둔다.
        if isRefreshing {
            requestsToRetry.append(completion)
            return
        }
        
        isRefreshing = true
        refreshToken { [weak self] succeeded in
            guard let self = self else { return }
            
            self.lock.lock()
            defer { self.lock.unlock() }
            
            if succeeded {
                self.requestsToRetry.append(completion)
                self.requestsToRetry.forEach { $0(.retry) }
                self.requestsToRetry.removeAll()
            } else {
                // If refresh failed, don't retry any requests
                self.requestsToRetry.forEach { $0(.doNotRetry) }
                self.requestsToRetry.removeAll()
                completion(.doNotRetry)
            }
            
            self.isRefreshing = false
        }
    }
    
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        // Get the refresh token
        let refreshToken = SecureDataManager.shared.getData(label: .refreshToken)
        
        // Create a URL request to refresh the token
        let urlString = APIKey.backendURL + "/auth/token/refresh"
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                // Token refresh failed - logout user
                DispatchQueue.main.async {
                    // Clear tokens
                    SecureDataManager.shared.clearTokens()
                    
                    /// TODO : 토큰 생성 실패시 로그아웃 진행 로그인 화면 띄어주기
                    // Notify app to show login screen
                    NotificationCenter.default.post(name: Notification.Name("UserTokenExpired"), object: nil)
                }
                completion(false)
                return
            }

            do {
                // Parse the response - adjust according to your API response structure
                let tokenResponse = try JSONDecoder().decode(ApiResponse<AuthTokenDTO>.self, from: data)
                // Save the new tokens
                try SecureDataManager.shared.saveToken(authToken: tokenResponse.data)

                completion(true)
            } catch {
                print("Failed to decode refresh token response: \(error)")
                completion(false)
            }
        }

        task.resume()
    }
}
