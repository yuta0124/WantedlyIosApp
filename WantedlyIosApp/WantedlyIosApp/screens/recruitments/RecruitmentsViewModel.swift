import Foundation
import SwiftUI

struct RecruitmentsUiState {
    var searchText = ""
    var isLoading = false
    var recruitments: [Recruitment] = []
}

@MainActor
class RecruitmentsViewModel: ObservableObject {
    @Published private(set) var uiState = RecruitmentsUiState()
    private let repository = WantedlyRepository()
    
    func onAction(_ intent: RecruitmentsIntent) {
        switch intent {
        case .onAppear:
            onAppear()
        case .search:
            onSearch()
        case .onSearchTextChanged(let text):
            onSearchTextChanged(text)
        }
    }
    
    private func onAppear() {
        Task {
            await fetchRecruitments()
        }
    }
    
    private func onSearchTextChanged(_ text: String) {
        uiState.searchText = text
    }
    
    private func onSearch() {
        Task {
            await fetchRecruitments(uiState.searchText)
        }
    }
    
    private func fetchRecruitments(_ keyword: String? = nil) async {
        uiState.isLoading = true
        
        let result = await repository.fetchRecruitments(
            keyword: keyword,
            page: 1
        )
        
        switch result {
        case .success(let response):
            uiState.recruitments = Recruitment.from(response)
            print("取得件数: \(uiState.recruitments.count)件")
        case .failure(let error):
            // TODO: エラーハンドリング
            print("募集一覧取得エラー: \(error.localizedDescription)")
        }
        
        uiState.isLoading = false
    }
}
