import Foundation
import RealmSwift

class BookmarkedEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var companyLogoImage: String
    @Persisted var companyName: String
    @Persisted var thumbnailUrl: String
    @Persisted var title: String
}
