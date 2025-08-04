import Foundation

class WantedlyRepository {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchRecruitments(keyword: String? = nil, page: Int = 1) async -> Result<RecruitmentsResponse, NetworkError> {
        var parameters: [String: String] = [:]
        
        if let keyword = keyword {
            parameters["q"] = keyword
        }
        parameters["page"] = String(page)
        
        do {
            let response: RecruitmentsResponse = try await networkClient.fetch("projects", parameters: parameters)
            return .success(response)
        } catch {
            return .failure(error.toNetworkError())
        }
    }
}
