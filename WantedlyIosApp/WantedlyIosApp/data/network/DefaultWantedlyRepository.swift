import Foundation

final class DefaultWantedlyRepository: WantedlyRepository {
    private let networkClient: NetworkClient
    private let realmManager = RealmManager.shared
    
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
        
    func addBookmark(_ recruitment: Recruitment) -> Bool {
        let success = realmManager.addBookmarkedRecruitment(recruitment)
        return success
    }
    
    func removeBookmark(id: Int) -> Bool {
        let success = realmManager.removeBookmarkedRecruitment(id: id)
        return success
    }
    
    func isBookmarked(id: Int) -> Bool {
        return realmManager.isBookmarked(id: id)
    }
}

