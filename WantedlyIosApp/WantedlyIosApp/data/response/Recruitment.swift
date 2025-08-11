import Foundation

struct Recruitment {
    let id: Int
    let title: String
    let companyName: String
    let canBookmark: Bool
    let companyLogoImage: String
    let thumbnailUrl: String
}

extension Recruitment {
    static func from(_ response: RecruitmentsResponse) -> [Recruitment] {
        return response.data.map { recruitmentData in
            Recruitment(
                id: recruitmentData.id,
                title: recruitmentData.title,
                companyName: recruitmentData.company.name,
                canBookmark: recruitmentData.canBookmark,
                companyLogoImage: recruitmentData.company.avatar?.original ?? "",
                thumbnailUrl: recruitmentData.image.original
            )
        }
    }
}
