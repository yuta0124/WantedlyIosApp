import Combine
import Foundation

final class DefaultWantedlyRepository: WantedlyRepository {
    private let networkClient: NetworkClient
    private let realmManager = RealmManager.shared
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    var bookmarkedCompanies: AnyPublisher<[BookmarkedRecruitmentTable], Never> {
        return realmManager.getBookmarkedRecruitmentsPublisher()
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
        
    func addBookmark(_ recruitment: Recruitment) -> Bool {
        let success = realmManager.addBookmarkedRecruitment(recruitment)
        return success
    }
    
    func removeBookmark(_ id: Int) -> Bool {
        let success = realmManager.removeBookmarkedRecruitment(id: id)
        return success
    }
    
    func isBookmarked(_ id: Int) -> Bool {
        return realmManager.isBookmarked(id: id)
    }
}
