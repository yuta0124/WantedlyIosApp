import Foundation
import SwiftUI

struct RecruitmentsUiState {
    var searchText = ""
    var isLoading = false
}

@MainActor
class RecruitmentsViewModel: ObservableObject {
    @Published private(set) var uiState = RecruitmentsUiState()
    
    func onAction(_ intent: RecruitmentsIntent) {
        switch intent {
        case .onAppear:
            onAppear()
        case .onSearchTextChanged(let text):
            onSearchTextChanged(text)
        }
    }
        
    private func onAppear() {
        // 画面表示時の処理、isLoadingをtrueにする
    }
    
    private func onSearchTextChanged(_ text: String) {
        uiState.searchText = text
    }
}
