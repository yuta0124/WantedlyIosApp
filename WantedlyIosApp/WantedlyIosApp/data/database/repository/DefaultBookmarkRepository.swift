import Combine
import Foundation

final class DefaultBookmarkRepository: BookmarkRepository {
    private let realmManager = RealmManager.shared
    
    var bookmarkedEntities: AnyPublisher<[BookmarkedEntity], Never> {
        return realmManager.getBookmarkedEntitiesPublisher()
    }
    
    func addBookmark(_ entity: BookmarkedEntity) -> Bool {
        return realmManager.addBookmarkedEntity(entity)
    }
    
    func removeBookmark(_ id: Int) -> Bool {
        return realmManager.removeBookmarkedEntity(id: id)
    }
    
    func isBookmarked(_ id: Int) -> Bool {
        return realmManager.isBookmarked(id: id)
    }
}
