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
        case .onSearchTextChanged(let text):
            onSearchTextChanged(text)
        }
    }
    
    private func onAppear() {
        Task {
            uiState.isLoading = true
            
            let result = await repository.fetchRecruitments(
                keyword: uiState.searchText.isEmpty ? nil : uiState.searchText,
                page: 1
            )
            
            switch result {
            case .success(let response):
                uiState.recruitments = Recruitment.from(response)
                print("取得した募集情報: \(uiState.recruitments.count)件")
            case .failure(let error):
                // TODO: エラーハンドリング
                print("募集情報取得エラー: \(error.localizedDescription)")
            }
            
            uiState.isLoading = false
        }
    }
    
    private func onSearchTextChanged(_ text: String) {
        uiState.searchText = text
    }
}
