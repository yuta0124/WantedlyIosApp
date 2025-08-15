import Foundation
import RealmSwift

class BookmarkedRecruitmentTable: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var companyLogoImage: String
    @Persisted var companyName: String
    @Persisted var thumbnailUrl: String
    @Persisted var title: String
    
    convenience init(from recruitment: Recruitment) {
        self.init()
        self.id = recruitment.id
        self.companyLogoImage = recruitment.companyLogoImage
        self.companyName = recruitment.companyName
        self.thumbnailUrl = recruitment.thumbnailUrl
        self.title = recruitment.title
    }
}
