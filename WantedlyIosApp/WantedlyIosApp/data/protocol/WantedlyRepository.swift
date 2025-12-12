import Combine
import Foundation

protocol WantedlyRepository {
    var bookmarkedCompanies: AnyPublisher<[BookmarkedRecruitmentTable], Never> { get }

    func fetchRecruitments(keyword: String?, page: Int) async -> Result<RecruitmentsResponse, NetworkError>
    func fetchRecruitmentDetail(_ id: Int) async -> Result<RecruitmentDetailResponse, NetworkError>
    func addBookmark(_ recruitment: Recruitment) -> Bool
    @discardableResult func removeBookmark(id: Int) -> Bool
    func isBookmarked(id: Int) -> Bool
}
