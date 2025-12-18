import Foundation

final class DefaultWantedlyRepository: WantedlyRepository {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchRecruitments(keyword: String?, page: Int) async -> Result<RecruitmentsResponse, NetworkError> {
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
    
    func fetchRecruitmentDetail(_ id: Int) async -> Result<RecruitmentDetailResponse, NetworkError> {
        do {
            let response: RecruitmentDetailResponse = try await networkClient.fetch("projects/\(id)", parameters: nil)
            return .success(response)
        } catch {
            return .failure(error.toNetworkError())
        }
    }
}

