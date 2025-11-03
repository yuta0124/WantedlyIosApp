import Combine
import Foundation

protocol WantedlyRepository {
    var bookmarkedCompanies: AnyPublisher<[BookmarkedRecruitmentTable], Never> { get }

    func fetchRecruitments(keyword: String?, page: Int) async -> Result<RecruitmentsResponse, NetworkError>
    func addBookmark(_ recruitment: Recruitment) -> Bool
    func removeBookmark(id: Int) -> Bool
    func isBookmarked(id: Int) -> Bool
}

