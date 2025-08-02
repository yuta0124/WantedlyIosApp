import Foundation
import SwiftUI

struct RecruitmentsUiState {
    var searchText = ""
    var isLoading = false
}

@MainActor
class RecruitmentsViewModel: ObservableObject {
    @Published private(set) var uiState = RecruitmentsUiState()
    
    init() {
        // 初期化処理
    }
    
    // MARK: - Public Methods
    
    func onAction(_ intent: RecruitmentsIntent) {
        switch intent {
        case .onAppear:
            onAppear()
        case .onSearchTextChanged(let text):
            onSearchTextChanged(text)
        }
    }
    
    // MARK: - Private Methods
    
    private func onAppear() {
        // 画面表示時の処理
    }
    
    private func onSearchTextChanged(_ text: String) {
        uiState.searchText = text
    }
}
