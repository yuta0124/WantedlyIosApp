import Foundation
import RealmSwift

class BookmarkedRecruitmentTable: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var companyLogoImage: String
    @Persisted var companyName: String
    @Persisted var thumbnailUrl: String
    @Persisted var title: String
    
    convenience init(id: Int, companyLogoImage: String, companyName: String, thumbnailUrl: String, title: String) {
        self.init()
        self.id = id
        self.companyLogoImage = companyLogoImage
        self.companyName = companyName
        self.thumbnailUrl = thumbnailUrl
        self.title = title
    }
}
