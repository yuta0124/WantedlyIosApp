
struct Recruitment {
    let id: Int
    let title: String
    let companyName: String
    let isBookmarked: Bool
    let companyLogoImage: String
    let thumbnailUrl: String
    
    static func from(_ response: RecruitmentsResponse) -> [Recruitment] {
        return response.data.map { recruitmentData in
            Recruitment(
                id: recruitmentData.id,
                title: recruitmentData.title,
                companyName: recruitmentData.company.name,
                isBookmarked: recruitmentData.canBookmark,
                companyLogoImage: recruitmentData.company.avatar?.original ?? "",
                thumbnailUrl: recruitmentData.image.original
            )
        }
    }

    func toBookmarkedRecruitmentTable() -> BookmarkedRecruitmentTable {
        return BookmarkedRecruitmentTable(
            id: id,
            companyLogoImage: companyLogoImage,
            companyName: companyName,
            thumbnailUrl: thumbnailUrl,
            title: title
        )
    }
}
