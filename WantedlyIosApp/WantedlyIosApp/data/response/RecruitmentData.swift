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
}
