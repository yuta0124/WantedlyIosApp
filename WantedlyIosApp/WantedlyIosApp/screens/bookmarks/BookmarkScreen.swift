import SwiftUI

enum BookmarkIntent {
    case bookmarkClick(Int)
}

struct BookmarkScreen: View {
    @StateObject private var viewModel = BookmarkViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.uiState.loading == .empty {
                    BookmarkEmptyView()
                } else {
                    BookmarkListView(
                        recruitments: viewModel.uiState.recruitments,
                        onAction: { intent in
                            viewModel.onAction(intent)
                        }
                    )
                }
            }
            .navigationTitle("bookmarks")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Int.self) { recruitmentId in
                DetailScreen(recruitmentId: recruitmentId)
            }
        }
    }
}

struct BookmarkEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("bookmark_screen_content")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct BookmarkListView: View {
    let recruitments: [Recruitment]
    let onAction: (BookmarkIntent) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(recruitments, id: \.id) { recruitment in
                    NavigationLink(value: recruitment.id) {
                        RecruitmentCardView(
                            companyLogoURL: recruitment.companyLogoImage,
                            companyName: recruitment.companyName,
                            thumbnailURL: recruitment.thumbnailUrl,
                            description: recruitment.title,
                            recruitmentId: recruitment.id,
                            isBookmarked: recruitment.isBookmarked,
                            onBookmarkToggled: {
                                onAction(.bookmarkClick(recruitment.id))
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    BookmarkScreen()
}
