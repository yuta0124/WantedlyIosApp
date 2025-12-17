import Foundation

protocol WantedlyRepository {
    func fetchRecruitments(keyword: String?, page: Int) async -> Result<RecruitmentsResponse, NetworkError>
    func fetchRecruitmentDetail(_ id: Int) async -> Result<RecruitmentDetailResponse, NetworkError>
}
