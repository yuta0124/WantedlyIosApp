import Foundation

struct Staffing: Codable {
    let userId: Int
    let name: String
    let description: String?
    let isLeader: Bool?
    let facebookUid: String?
}
