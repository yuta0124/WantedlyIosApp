import Foundation

struct Company: Codable {
    let id: Int
    let name: String
    let url: String?
    let addressPrefix: String?
    let addressSuffix: String?
    let avatar: Avatar?
    let foundedOn: String?
    let founder: String?
    let latitude: Double?
    let longitude: Double?
    let payrollNumber: Int?
}
