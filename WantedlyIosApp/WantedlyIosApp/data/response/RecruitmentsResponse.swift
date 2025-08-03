import Foundation

struct RecruitmentsResponse: Codable {
    let data: [RecruitmentData]
    let metadata: Metadata?
    
    func toRecruitments() -> [Recruitment] {
        return data.map { recruitmentData in
            Recruitment(
                id: recruitmentData.id,
                title: recruitmentData.title,
                companyName: recruitmentData.company.name,
                canBookmark: recruitmentData.canBookmark,
                companyLogoImage: recruitmentData.company.avatar?.original,
                thumbnailUrl: recruitmentData.image.original
            )
        }
    }
}
