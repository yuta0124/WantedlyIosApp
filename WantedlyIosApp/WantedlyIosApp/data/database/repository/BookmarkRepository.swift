import Combine
import Foundation

protocol BookmarkRepository {
    var bookmarkedEntities: AnyPublisher<[BookmarkedEntity], Never> { get }
    
    func addBookmark(_ entity: BookmarkedEntity) -> Bool
    @discardableResult func removeBookmark(_ id: Int) -> Bool
    func isBookmarked(_ id: Int) -> Bool
}
