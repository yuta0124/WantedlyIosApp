import Combine
import Foundation

enum LoadingState {
    case none
    case empty
}

struct BookmarkUiState {
    var loading: LoadingState = .none
    var recruitments: [Recruitment] = []
}

enum BookmarkIntent {
    case bookmarkClick(Int)
}

@MainActor
class BookmarkViewModel: ObservableObject {
    @Published private(set) var uiState = BookmarkUiState()
    private let repository: WantedlyRepository = DefaultWantedlyRepository()
    
    init() {
        setupStateCombine()
    }
    
    func onAction(_ intent: BookmarkIntent) {
        switch intent {
        case .bookmarkClick(let id):
            repository.removeBookmark(id: id)
        }
    }
    
    private func setupStateCombine() {
        repository.bookmarkCompanies
            .map { bookmarkedRecruitments in
                let recruitments = bookmarkedRecruitments.map { table in
                    Recruitment(
                        id: table.id,
                        title: table.title,
                        companyName: table.companyName,
                        isBookmarked: true,
                        companyLogoImage: table.companyLogoImage,
                        thumbnailUrl: table.thumbnailUrl
                    )
                }
                let loading: LoadingState = recruitments.isEmpty ? .empty : .none
                
                return BookmarkUiState(
                    loading: loading,
                    recruitments: recruitments
                )
            }
            .assign(to: &$uiState)
    }
}
