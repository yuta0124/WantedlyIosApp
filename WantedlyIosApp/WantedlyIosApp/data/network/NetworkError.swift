import Foundation

enum NetworkError: LocalizedError {
    // status code: 400~499
    case badRequestException
    // status code: 500~599
    case serverException
    case networkException
    case timeoutException
    case unexpectedException
}

extension Error {
    func toNetworkError() -> NetworkError {
        if let urlError = self as? URLError {
            switch urlError.code {
            case .timedOut:
                return .timeoutException
            case .notConnectedToInternet, .networkConnectionLost:
                return .networkException
            default:
                return .unexpectedException
            }
        }
        
        if self is DecodingError {
            return .unexpectedException
        }
        
        return .unexpectedException
    }
}
