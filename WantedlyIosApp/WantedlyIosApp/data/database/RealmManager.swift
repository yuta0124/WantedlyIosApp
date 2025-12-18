import Combine
import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    // swiftlint:disable:next force_try
    let realm: Realm = try! Realm()
    private var notificationToken: NotificationToken?
    private var bookmarkedEntitiesPublisher = PassthroughSubject<[BookmarkedEntity], Never>()
    
    private init() {
        setupObserver()
    }
    
    func addBookmarkedEntity(_ entity: BookmarkedEntity) -> Bool {
        do {
            try realm.write {
                realm.add(entity, update: .modified)
            }
            return true
        } catch {
            print("addBookmarkedEntity: \(error)")
            return false
        }
    }
    
    func removeBookmarkedEntity(id: Int) -> Bool {
        do {
            if let bookmarkedEntity = realm.object(ofType: BookmarkedEntity.self, forPrimaryKey: id) {
                try realm.write {
                    realm.delete(bookmarkedEntity)
                }
                return true
            }
            return false
        } catch {
            print("removeBookmarkedEntity: \(error)")
            return false
        }
    }
    
    func isBookmarked(id: Int) -> Bool {
        return realm.object(ofType: BookmarkedEntity.self, forPrimaryKey: id) != nil
    }
    
    func getBookmarkedEntitiesPublisher() -> AnyPublisher<[BookmarkedEntity], Never> {
        return bookmarkedEntitiesPublisher.eraseToAnyPublisher()
    }
    
    private func setupObserver() {
        let results = realm.objects(BookmarkedEntity.self)
        notificationToken = results.observe { [weak self] _ in
            let bookmarkedEntities = Array(results)
            self?.bookmarkedEntitiesPublisher.send(bookmarkedEntities)
        }
    }
}
