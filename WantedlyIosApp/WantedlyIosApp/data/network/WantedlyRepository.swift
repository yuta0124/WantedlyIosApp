import Foundation

class WantedlyRepository {
    private let networkClient = NetworkClient()
    
    func fetchRecruitments(keyword: String? = nil, page: Int = 1) async throws -> RecruitmentsResponse {
        var parameters: [String: String] = [:]
        
        if let keyword = keyword {
            parameters["q"] = keyword
        }
        parameters["page"] = String(page)
        
        return try await networkClient.fetch("projects", parameters: parameters)
    }
}
