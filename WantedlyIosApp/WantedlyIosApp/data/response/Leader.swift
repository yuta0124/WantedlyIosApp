import Foundation

struct Leader: Codable {
    let facebookUid: String?
    let nameEn: String?
    let nameJa: String?
    
    enum CodingKeys: String, CodingKey {
        case facebookUid = "facebook_uid"
        case nameEn = "name_en"
        case nameJa = "name_ja"
    }
}
