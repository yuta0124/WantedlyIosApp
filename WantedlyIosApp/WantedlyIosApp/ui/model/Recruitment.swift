
struct Recruitment {
    let id: Int
    let title: String
    let companyName: String
    var isBookmarked: Bool
    let companyLogoImage: String
    let thumbnailUrl: String
    
    static func create(from response: RecruitmentsResponse) -> [Recruitment] {
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

    func toBookmarkedEntity() -> BookmarkedEntity {
        let entity = BookmarkedEntity()
        entity.id = id
        entity.companyLogoImage = companyLogoImage
        entity.companyName = companyName
        entity.thumbnailUrl = thumbnailUrl
        entity.title = title
        
        return entity
    }
}
