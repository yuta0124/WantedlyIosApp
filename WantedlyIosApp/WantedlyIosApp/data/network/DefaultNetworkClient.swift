import Foundation

final class DefaultNetworkClient: NetworkClient {
    private let baseURL: String
    
    init() {
        guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String else {
            fatalError("BaseURL not found in Info.plist")
        }
        self.baseURL = baseURL
    }
    
    func fetch<T: Decodable>(_ endpoint: String, parameters: [String: String]?) async throws -> T {
        var urlComponents = URLComponents(string: baseURL + endpoint)
        
        if let parameters = parameters {
            urlComponents?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.unexpectedException
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unexpectedException
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499:
                throw NetworkError.badRequestException
            case 500...599:
                throw NetworkError.serverException
            default:
                throw NetworkError.unexpectedException
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error.toNetworkError()
        }
    }
}
