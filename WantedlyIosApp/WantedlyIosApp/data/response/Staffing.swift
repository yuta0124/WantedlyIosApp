import Foundation

struct Staffing: Codable {
    let userId: Int
    let name: String
    let description: String?
    let isLeader: Bool?
    let facebookUid: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name, description
        case isLeader = "is_leader"
        case facebookUid = "facebook_uid"
    }
}
