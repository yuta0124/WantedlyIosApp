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
    
    enum CodingKeys: String, CodingKey {
        case id, name, url
        case addressPrefix = "address_prefix"
        case addressSuffix = "address_suffix"
        case avatar
        case foundedOn = "founded_on"
        case founder, latitude, longitude
        case payrollNumber = "payroll_number"
    }
}
