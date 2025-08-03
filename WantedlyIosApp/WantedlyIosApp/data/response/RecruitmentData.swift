import Foundation

struct RecruitmentData: Codable {
    let id: Int
    let image: ImageData
    let title: String
    let company: Company
    let description: String?
    let canBookmark: Bool
    let canSupport: Bool?
    let candidateCount: Int?
    let categoryMessage: String?
    let leader: Leader?
    let location: String?
    let locationSuffix: String?
    let lookingFor: String?
    let pageView: Int?
    let publishedAt: String?
    let staffings: [Staffing]?
    let staffingsCount: Int?
    let supportCount: Int?
    let supported: Bool?
    let useWebview: Bool?
    let videoAvailable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, image, title, company, description
        case canBookmark = "can_bookmark"
        case canSupport = "can_support"
        case candidateCount = "candidate_count"
        case categoryMessage = "category_message"
        case leader, location
        case locationSuffix = "location_suffix"
        case lookingFor = "looking_for"
        case pageView = "page_view"
        case publishedAt = "published_at"
        case staffings
        case staffingsCount = "staffings_count"
        case supportCount = "support_count"
        case supported
        case useWebview = "use_webview"
        case videoAvailable = "video_available"
    }
}
