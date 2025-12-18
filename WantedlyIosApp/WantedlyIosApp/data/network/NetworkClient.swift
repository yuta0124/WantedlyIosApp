import Foundation

protocol NetworkClient {
    func fetch<T: Decodable>(_ endpoint: String, parameters: [String: String]?) async throws -> T
}
