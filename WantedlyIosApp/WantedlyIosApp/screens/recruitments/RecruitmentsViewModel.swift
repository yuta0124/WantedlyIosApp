//
//  RecruitmentsViewModel.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/11.
//
import Combine
import Foundation
import Observation

@Observable @MainActor
class RecruitmentsViewModel {
    private let wantedlyRepository: WantedlyRepository
    private let bookmarkRepository: BookmarkRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: UiState
    private(set) var searchText = ""
    private(set) var isLoading = true
    private(set) var isLoadingMore = false
    private(set) var recruitments: [Recruitment] = []
    
    private var currentPage = RecruitmentsConstants.initialPage
    private var hasMoreData = true
    private var previousBookmarkedIds: Set<Int> = []
    
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
    
    private func fetchRecruitments(keyword: String? = nil, page: Int = RecruitmentsConstants.initialPage) async {
        if page == RecruitmentsConstants.initialPage {
            isLoading = true
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
                recruitments = updatedRecruitments
            } else {
                recruitments.append(contentsOf: updatedRecruitments)
            }
            
            hasMoreData = newRecruitments.count >= RecruitmentsConstants.pageSize
            currentPage = page
            
        case .failure(let error):
            print("募集一覧取得エラー: \(error.localizedDescription)")
            // TODO: エラーハンドリング
        }
        
        if page == RecruitmentsConstants.initialPage {
            isLoading = false
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
        guard let recruitment = recruitments.first(where: { $0.id == recruitmentId }) else {
            return nil
        }
        return updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: isBookmarked)
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
        let currentBookmarkedIds = Set(bookmarkedEntities.map { $0.id })
        
        let addedIds = currentBookmarkedIds.subtracting(previousBookmarkedIds)
        let removedIds = previousBookmarkedIds.subtracting(currentBookmarkedIds)
        let changedIds = addedIds.union(removedIds)
        
        guard !changedIds.isEmpty else { return }
        
        for (index, recruitment) in recruitments.enumerated() where changedIds.contains(recruitment.id) {
            let isBookmarked = currentBookmarkedIds.contains(recruitment.id)
            recruitments[index] = updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: isBookmarked)
        }
        
        previousBookmarkedIds = currentBookmarkedIds
    }
    
    func onSearchTextChanged(_ value: String) {
        searchText = value
    }
    
    func onSearch() {
        Task {
            currentPage = RecruitmentsConstants.initialPage
            hasMoreData = true
            isLoading = true
            await fetchRecruitments(keyword: searchText, page: RecruitmentsConstants.initialPage)
        }
    }
    
    func loadMore() {
        guard hasMoreData && !isLoadingMore else { return }
        
        Task {
            isLoadingMore = true
            let nextPage = currentPage + 1
            await fetchRecruitments(keyword: searchText, page: nextPage)
            isLoadingMore = false
        }
    }
    
    func onBookmarkToggled(for recruitmentId: Int) {
        guard let index = recruitments.firstIndex(where: { $0.id == recruitmentId }) else {
            return
        }
        
        let recruitment = recruitments[index]
        recruitments[index] = updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: !recruitment.isBookmarked)
        
        if recruitments[index].isBookmarked {
            let success = bookmarkRepository.addBookmark(recruitment.toBookmarkedEntity())
            if !success {
                recruitments[index] = updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: !recruitment.isBookmarked)
            }
        } else {
            let success = bookmarkRepository.removeBookmark(recruitmentId)
            if !success {
                recruitments[index] = updateRecruitmentBookmarkStatus(recruitment: recruitment, isBookmarked: !recruitment.isBookmarked)
            }
        }
    }
}
