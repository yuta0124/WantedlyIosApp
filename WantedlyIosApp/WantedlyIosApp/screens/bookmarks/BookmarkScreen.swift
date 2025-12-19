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
                    EmptyView()
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
    
    private func EmptyView() -> some View {
        Text("ブックマークがありません")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.gray.opacity(0.6))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
