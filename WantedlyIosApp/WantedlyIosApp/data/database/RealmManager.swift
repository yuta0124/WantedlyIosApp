import Combine
import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private var realm: Realm?
    private var notificationToken: NotificationToken?
    private var bookmarkedRecruitmentsPublisher = PassthroughSubject<[BookmarkedRecruitmentTable], Never>()
    
    private init() {
        setupRealm()
        setupObserver()
    }
    
    private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Realm初期化エラー: \(error)")
        }
    }
    
    func addBookmarkedRecruitment(_ recruitment: Recruitment) -> Bool {
        guard let realm = realm else { return false }
        
        do {
            let bookmarkedRecruitment = BookmarkedRecruitmentTable(from: recruitment)
            try realm.write {
                realm.add(bookmarkedRecruitment, update: .modified)
            }
            return true
        } catch {
            print("お気に入り追加エラー: \(error)")
            return false
        }
    }
    
    func removeBookmarkedRecruitment(id: Int) -> Bool {
        guard let realm = realm else { return false }
        
        do {
            if let bookmarkedRecruitment = realm.object(ofType: BookmarkedRecruitmentTable.self, forPrimaryKey: id) {
                try realm.write {
                    realm.delete(bookmarkedRecruitment)
                }
                return true
            }
            return false
        } catch {
            print("お気に入り削除エラー: \(error)")
            return false
        }
    }
    
    func isBookmarked(id: Int) -> Bool {
        guard let realm = realm else { return false }
        return realm.object(ofType: BookmarkedRecruitmentTable.self, forPrimaryKey: id) != nil
    }
    
    func getBookmarkedRecruitmentsPublisher() -> AnyPublisher<[BookmarkedRecruitmentTable], Never> {
        return bookmarkedRecruitmentsPublisher.eraseToAnyPublisher()
    }
    
    private func setupObserver() {
        guard let realm = realm else { return }
        
        let results = realm.objects(BookmarkedRecruitmentTable.self)
        notificationToken = results.observe { [weak self] _ in
            let bookmarkedRecruitments = Array(results)
            self?.bookmarkedRecruitmentsPublisher.send(bookmarkedRecruitments)
        }
    }
}
