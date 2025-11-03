import Combine
import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    let realm: Realm = try! Realm()
    private var notificationToken: NotificationToken?
    private var bookmarkedRecruitmentsPublisher = PassthroughSubject<[BookmarkedRecruitmentTable], Never>()
    
    private init() {
        setupObserver()
    }
    
    func addBookmarkedRecruitment(_ recruitment: Recruitment) -> Bool {
        do {
            let bookmarkedRecruitment = recruitment.toBookmarkedRecruitmentTable()
            try realm.write {
                realm.add(bookmarkedRecruitment, update: .modified)
            }
            return true
        } catch {
            print("addBookmarkedRecruitment: \(error)")
            return false
        }
    }
    
    func removeBookmarkedRecruitment(id: Int) -> Bool {
        do {
            if let bookmarkedRecruitment = realm.object(ofType: BookmarkedRecruitmentTable.self, forPrimaryKey: id) {
                try realm.write {
                    realm.delete(bookmarkedRecruitment)
                }
                return true
            }
            return false
        } catch {
            print("removeBookmarkedRecruitment: \(error)")
            return false
        }
    }
    
    func isBookmarked(id: Int) -> Bool {
        return realm.object(ofType: BookmarkedRecruitmentTable.self, forPrimaryKey: id) != nil
    }
    
    func getBookmarkedRecruitmentsPublisher() -> AnyPublisher<[BookmarkedRecruitmentTable], Never> {
        return bookmarkedRecruitmentsPublisher.eraseToAnyPublisher()
    }
    
    private func setupObserver() {
        let results = realm.objects(BookmarkedRecruitmentTable.self)
        notificationToken = results.observe { [weak self] _ in
            let bookmarkedRecruitments = Array(results)
            self?.bookmarkedRecruitmentsPublisher.send(bookmarkedRecruitments)
        }
    }
}
