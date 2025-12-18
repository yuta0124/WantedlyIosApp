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
    private let bookmarkRepository: BookmarkRepository
    private var cancellables = Set<AnyCancellable>()

    init(bookmarkRepository: BookmarkRepository = DefaultBookmarkRepository()) {
        self.bookmarkRepository = bookmarkRepository
        setupStateCombine()
    }
    
    func onAction(_ intent: BookmarkIntent) {
        switch intent {
        case .bookmarkClick(let id):
            bookmarkRepository.removeBookmark(id)
        }
    }
    
    private func setupStateCombine() {
        bookmarkRepository.bookmarkedEntities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarkedEntities in
                guard let self = self else { return }
                
                let loading: BookmarkLoadingState = if bookmarkedEntities.isEmpty {
                    .empty
                } else {
                    .none
                }
                
                let recruitments: [Recruitment] = bookmarkedEntities.map {
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
    
    private func convertToRecruitments(from entities: [BookmarkedEntity]) -> [Recruitment] {
        return entities.map { entity in
            Recruitment(
                id: entity.id,
                title: entity.title,
                companyName: entity.companyName,
                isBookmarked: true,
                companyLogoImage: entity.companyLogoImage,
                thumbnailUrl: entity.thumbnailUrl
            )
        }
    }
}
