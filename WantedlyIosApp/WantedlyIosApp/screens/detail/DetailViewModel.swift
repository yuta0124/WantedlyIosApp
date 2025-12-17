//
//  DetailViewModel.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/11.
//
import Combine
import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    private let repository: WantedlyRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: UIState
    @Published private(set) var recruitmentId: Int = -1
    @Published private(set) var title: String = ""
    @Published private(set) var companyName: String = ""
    @Published private(set) var thumbnailUrl: String = ""
    @Published private(set) var isBookmarked: Bool = false
    @Published private(set) var companyLogoImage: String = ""
    @Published private(set) var whatDescription: String = ""
    @Published private(set) var whyDescription: String = ""
    @Published private(set) var howDescription: String = ""
    @Published private(set) var isLoading: Bool = true
    
    init(
        recruitmentId: Int,
        wantedlyRepository: WantedlyRepository = DefaultWantedlyRepository()
    ) {
        self.recruitmentId = recruitmentId
        self.repository = wantedlyRepository
        
        Task {
            await fetchRecruitmentDetail()
        }
    }
    
    private func fetchRecruitmentDetail() async {
        let result = await repository.fetchRecruitmentDetail(self.recruitmentId)
        
        switch result {
        case .success(let response):
            onSuccess(response.data)
            
        case .failure(let error):
            print("詳細取得エラー: \(error.localizedDescription)")
            // TODO: エラーハンドリング
        }
        
        self.isLoading = false
    }
    
    private func onSuccess(_ response: RecruitmentDetailData) {
        self.title = response.title
        self.companyName = response.company.name
        self.thumbnailUrl = response.image.original
        self.isBookmarked = repository.isBookmarked(recruitmentId)
        self.companyLogoImage = response.company.avatar?.original ?? ""
        self.whatDescription = response.whatDescription
        self.whyDescription = response.whyDescription
        self.howDescription = response.howDescription
        
        setupBookmarkObserver()
    }
    
    private func setupBookmarkObserver() {
        repository.bookmarkedCompanies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarkedRecruitments in
                self?.isBookmarked = bookmarkedRecruitments.contains(where: { $0.id == self?.recruitmentId })
            }
            .store(in: &cancellables)
    }
    
    private func generateRecruitmentFromCurrentUiState() -> Recruitment {
        return Recruitment(
            id: recruitmentId,
            title: title,
            companyName: companyName,
            isBookmarked: isBookmarked,
            companyLogoImage: companyLogoImage,
            thumbnailUrl: thumbnailUrl
        )
    }
    
    func onBookmarkToggle() {
        isBookmarked = !isBookmarked
        
        if isBookmarked {
            let success = repository.addBookmark(generateRecruitmentFromCurrentUiState())
            if !success {
                isBookmarked = !isBookmarked
            }
        } else {
            let success = repository.removeBookmark(recruitmentId)
            if !success {
                isBookmarked = !isBookmarked
            }
        }
    }
}
