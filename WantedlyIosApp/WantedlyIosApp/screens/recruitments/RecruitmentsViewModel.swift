import Foundation
import SwiftUI

struct RecruitmentsUiState {
    var searchText = ""
    var isLoading = false
    var isLoadingMore = false
    var hasMoreData = true
    var recruitments: [Recruitment] = []
}

@MainActor
class RecruitmentsViewModel: ObservableObject {
    @Published private(set) var uiState = RecruitmentsUiState()
    private let repository = WantedlyRepository()
    private var currentPage = 1
    
    func onAction(_ intent: RecruitmentsIntent) {
        switch intent {
        case .onAppear:
            onAppear()
        case .search:
            onSearch()
        case .onSearchTextChanged(let text):
            onSearchTextChanged(text)
        case .loadMore:
            loadMore()
        }
    }
    
    private func onAppear() {
        Task {
            resetPagination()
            await fetchRecruitments()
        }
    }
    
    private func onSearchTextChanged(_ text: String) {
        uiState.searchText = text
    }
    
    private func onSearch() {
        Task {
            resetPagination()
            await fetchRecruitments(uiState.searchText, page: 1)
        }
    }
    
    private func fetchRecruitments(_ keyword: String? = nil, page: Int = 1) async {
        if page == 1 {
            uiState.isLoading = true
        }
        
        let result = await repository.fetchRecruitments(
            keyword: keyword,
            page: page
        )
        
        switch result {
        case .success(let response):
            let newRecruitments = Recruitment.from(response)
            if page == 1 {
                uiState.recruitments = newRecruitments
            } else {
                uiState.recruitments.append(contentsOf: newRecruitments)
            }
            
            uiState.hasMoreData = newRecruitments.count >= 10
            currentPage = page
            
            print("取得件数: \(newRecruitments.count)件 (ページ: \(page))")
        case .failure(let error):
            // TODO: エラーハンドリング
            print("募集一覧取得エラー: \(error.localizedDescription)")
        }
        
        if page == 1 {
            uiState.isLoading = false
        }
    }
    
    private func loadMore() {
        guard uiState.hasMoreData && !uiState.isLoadingMore else { return }
        
        Task {
            uiState.isLoadingMore = true
            let nextPage = currentPage + 1
            await fetchRecruitments(uiState.searchText, page: nextPage)
            uiState.isLoadingMore = false
        }
    }
    
    // ページネーション状態をリセット
    private func resetPagination() {
        currentPage = 1
        uiState.hasMoreData = true
        uiState.recruitments.removeAll()
    }
}
