import Combine
import Foundation

enum BookmarkLoadingState {
    case none
    case empty
}

struct BookmarkUiState {
    var loading: BookmarkLoadingState = .none
    var recruitments: [Recruitment] = []
}

@MainActor
class BookmarkViewModel: ObservableObject {
    @Published private(set) var uiState = BookmarkUiState()
    private let repository: WantedlyRepository = DefaultWantedlyRepository()
    private var cancellables = Set<AnyCancellable>()

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
        repository.bookmarkedCompanies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarkedRecruitments in
                guard let self = self else { return }
                
                let loading: BookmarkLoadingState = if bookmarkedRecruitments.isEmpty {
                    .empty
                } else {
                    .none
                }
                
                let recruitments: [Recruitment] = bookmarkedRecruitments.map {
                    Recruitment(
                        id: $0.id,
                        title: $0.title,
                        companyName: $0.companyName,
                        isBookmarked: true,
                        companyLogoImage: $0.companyLogoImage,
                        thumbnailUrl: $0.thumbnailUrl
                    )
                }
                
                self.uiState = BookmarkUiState(
                    loading: loading,
                    recruitments: recruitments
                )
            }
            .store(in: &cancellables)
    }
    
    private func convertToRecruitments(from tables: [BookmarkedRecruitmentTable]) -> [Recruitment] {
        return tables.map { table in
            Recruitment(
                id: table.id,
                title: table.title,
                companyName: table.companyName,
                isBookmarked: true,
                companyLogoImage: table.companyLogoImage,
                thumbnailUrl: table.thumbnailUrl
            )
        }
    }
}
