import Combine
import Foundation

protocol BookmarkRepository {
    var bookmarkedRecruitments: AnyPublisher<[BookmarkedRecruitmentTable], Never> { get }
    
    func addBookmark(_ recruitment: Recruitment) -> Bool
    @discardableResult func removeBookmark(_ id: Int) -> Bool
    func isBookmarked(_ id: Int) -> Bool
}
