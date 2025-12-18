import Combine
import Foundation
import SwiftUI

struct RecruitmentsUiState {
    var searchText = ""
    var isLoading = false
    var isLoadingMore = false
    var recruitments: [Recruitment] = []
}

@MainActor
class RecruitmentsViewModel: ObservableObject {
    @Published private(set) var uiState = RecruitmentsUiState()
    private let wantedlyRepository: WantedlyRepository
    private let bookmarkRepository: BookmarkRepository
    private var currentPage = RecruitmentsConstants.initialPage
    private var hasMoreData = true
    private var cancellables = Set<AnyCancellable>()
    
    init(
        wantedlyRepository: WantedlyRepository = DefaultWantedlyRepository(),
        bookmarkRepository: BookmarkRepository = DefaultBookmarkRepository()
    ) {
        self.wantedlyRepository = wantedlyRepository
        self.bookmarkRepository = bookmarkRepository
        Task {
            setupBookmarkObserver()
            await fetchRecruitments()
        }
    }
    
    func onAction(_ intent: RecruitmentsIntent) {
        switch intent {
        case .search:
            onSearch()
        case .onSearchTextChanged(let text):
            onSearchTextChanged(text)
        case .loadMore:
            loadMore()
        case .toggleBookmark(let recruitmentId):
            toggleBookmark(recruitmentId: recruitmentId)
        }
    }
    
    private func onSearchTextChanged(_ text: String) {
        uiState.searchText = text
    }
    
    private func onSearch() {
        Task {
            currentPage = RecruitmentsConstants.initialPage
            hasMoreData = true
            uiState.isLoading = true
            await fetchRecruitments(uiState.searchText, page: RecruitmentsConstants.initialPage)
        }
    }
    
    private func fetchRecruitments(_ keyword: String? = nil, page: Int = RecruitmentsConstants.initialPage) async {
        if page == RecruitmentsConstants.initialPage {
            uiState.isLoading = true
        }
        
        let result = await wantedlyRepository.fetchRecruitments(
            keyword: keyword,
            page: page
        )
        
        switch result {
        case .success(let response):
            let newRecruitments = Recruitment.create(from: response)
            let updatedRecruitments = createUpdatedRecruitments(from: newRecruitments)
            
            if page == RecruitmentsConstants.initialPage {
                uiState.recruitments = updatedRecruitments
            } else {
                uiState.recruitments.append(contentsOf: updatedRecruitments)
            }
            
            hasMoreData = newRecruitments.count >= RecruitmentsConstants.pageSize
            currentPage = page
            
        case .failure(let error):
            print("募集一覧取得エラー: \(error.localizedDescription)")
            // TODO: エラーハンドリング
        }
        
        if page == RecruitmentsConstants.initialPage {
            uiState.isLoading = false
        }
    }
    
    private func createUpdatedRecruitments(from recruitments: [Recruitment]) -> [Recruitment] {
        return recruitments.map { recruitment in
            let isBookmarked = bookmarkRepository.isBookmarked(recruitment.id)
            return updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: isBookmarked)
        }
    }
    
    private func updateRecruitmentBookmarkStatus(recruitment: Recruitment, isBookmarked: Bool) -> Recruitment {
        return Recruitment(
            id: recruitment.id,
            title: recruitment.title,
            companyName: recruitment.companyName,
            isBookmarked: isBookmarked,
            companyLogoImage: recruitment.companyLogoImage,
            thumbnailUrl: recruitment.thumbnailUrl
        )
    }
    
    private func updateRecruitmentBookmarkStatus(recruitmentId: Int, isBookmarked: Bool) -> Recruitment? {
        guard let recruitment = uiState.recruitments.first(where: { $0.id == recruitmentId }) else {
            return nil
        }
        return updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: isBookmarked)
    }
    
    private func loadMore() {
        guard hasMoreData && !uiState.isLoadingMore else { return }
        
        Task {
            uiState.isLoadingMore = true
            let nextPage = currentPage + 1
            await fetchRecruitments(uiState.searchText, page: nextPage)
            uiState.isLoadingMore = false
        }
    }
    
    private func toggleBookmark(recruitmentId: Int) {
        guard let index = uiState.recruitments.firstIndex(where: { $0.id == recruitmentId }) else {
            return
        }
        
        let recruitment = uiState.recruitments[index]
        uiState.recruitments[index] = updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: !recruitment.isBookmarked)
        
        if uiState.recruitments[index].isBookmarked {
            let success = bookmarkRepository.addBookmark(recruitment.toBookmarkedEntity())
            if !success {
                uiState.recruitments[index] = updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: !recruitment.isBookmarked)
            }
        } else {
            let success = bookmarkRepository.removeBookmark(recruitmentId)
            if !success {
                uiState.recruitments[index] = updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: !recruitment.isBookmarked)
            }
        }
    }
    
    private func setupBookmarkObserver() {
        bookmarkRepository.bookmarkedEntities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarkedEntities in
                self?.updateBookmarkStatusFromDatabase(bookmarkedEntities)
            }
            .store(in: &cancellables)
    }
    
    private func updateBookmarkStatusFromDatabase(_ bookmarkedEntities: [BookmarkedEntity]) {
        let bookmarkedIds = Set(bookmarkedEntities.map { $0.id })
        
        uiState.recruitments = uiState.recruitments.map { recruitment in
            let isBookmarked = bookmarkedIds.contains(recruitment.id)
            return updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: isBookmarked)
        }
    }
}
