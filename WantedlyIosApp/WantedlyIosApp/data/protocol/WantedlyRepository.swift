import Foundation

protocol WantedlyRepository {
    func fetchRecruitments(keyword: String?, page: Int) async -> Result<RecruitmentsResponse, NetworkError>
    func addBookmark(_ recruitment: Recruitment) -> Bool
    func removeBookmark(id: Int) -> Bool
    func isBookmarked(id: Int) -> Bool
}

