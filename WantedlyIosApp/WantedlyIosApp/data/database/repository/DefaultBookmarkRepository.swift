import Combine
import Foundation

final class DefaultBookmarkRepository: BookmarkRepository {
    private let realmManager = RealmManager.shared
    
    var bookmarkedRecruitments: AnyPublisher<[BookmarkedRecruitmentTable], Never> {
        return realmManager.getBookmarkedRecruitmentsPublisher()
    }
    
    func addBookmark(_ recruitment: Recruitment) -> Bool {
        return realmManager.addBookmarkedRecruitment(recruitment)
    }
    
    func removeBookmark(_ id: Int) -> Bool {
        return realmManager.removeBookmarkedRecruitment(id: id)
    }
    
    func isBookmarked(_ id: Int) -> Bool {
        return realmManager.isBookmarked(id: id)
    }
}

