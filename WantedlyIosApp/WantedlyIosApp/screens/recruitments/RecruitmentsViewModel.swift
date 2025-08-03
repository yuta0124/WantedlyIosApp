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
            
            do {
                let response = try await repository.fetchRecruitments(
                    keyword: uiState.searchText.isEmpty ? nil : uiState.searchText,
                    page: 1
                )
                uiState.recruitments = response.toRecruitments()
                print("取得した募集情報: \(uiState.recruitments.count)件")
            } catch {
                print("募集情報取得エラー: \(error.localizedDescription)")
            }
            
            uiState.isLoading = false
        }
    }
    
    private func onSearchTextChanged(_ text: String) {
        uiState.searchText = text
    }
}
