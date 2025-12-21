//
//  BookmarkViewModel.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/11.
//
import Combine
import Foundation
import Observation

@Observable @MainActor
class BookmarkViewModel {
    private let bookmarkRepository: BookmarkRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: UiState
    private(set) var recruitments: [Recruitment]?
    
    init(bookmarkRepository: BookmarkRepository = DefaultBookmarkRepository()) {
        self.bookmarkRepository = bookmarkRepository
        setupStateCombine()
    }
    
    private func setupStateCombine() {
        bookmarkRepository.bookmarkedEntities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarkedEntities in
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
                
                self?.recruitments = recruitments
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
    
    func onBookmarkToggled(_ id: Int) {
        bookmarkRepository.removeBookmark(id)
    }
}
