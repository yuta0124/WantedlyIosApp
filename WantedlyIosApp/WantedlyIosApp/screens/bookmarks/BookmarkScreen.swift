import SwiftUI

struct BookmarkScreen: View {
    @StateObject private var viewModel = BookmarkViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.uiState.loading == .empty {
                    VStack {
                        Spacer()
                        Text("bookmark_screen_content")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.uiState.recruitments, id: \.id) { recruitment in
                                RecruitmentCardView(
                                    companyLogoURL: recruitment.companyLogoImage,
                                    companyName: recruitment.companyName,
                                    thumbnailURL: recruitment.thumbnailUrl,
                                    description: recruitment.title,
                                    recruitmentId: recruitment.id,
                                    isBookmarked: recruitment.isBookmarked,
                                    onBookmarkToggled: {
                                        viewModel.onAction(.bookmarkClick(recruitment.id))
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("bookmarks")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    BookmarkScreen()
}
