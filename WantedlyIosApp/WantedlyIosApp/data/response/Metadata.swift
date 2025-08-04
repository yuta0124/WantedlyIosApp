import Foundation

struct Metadata: Codable {
    let perPage: Int
    let totalObjects: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case totalObjects = "total_objects"
        case totalPages = "total_pages"
    }
}
