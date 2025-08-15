import SwiftUI

enum RecruitmentsIntent {
    case onAppear
    case onSearchTextChanged(String)
    case search
    case loadMore
    case toggleBookmark(Int)
}

struct RecruitmentsScreen: View {
    @StateObject private var viewModel = RecruitmentsViewModel()
    @FocusState private var isSearchFocused: Bool
    @State private var scrollToTop = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.uiState.recruitments.enumerated()), id: \.element.id) { index, recruitment in
                                RecruitmentCardView(
                                    companyLogoURL: recruitment.companyLogoImage,
                                    companyName: recruitment.companyName,
                                    thumbnailURL: recruitment.thumbnailUrl,
                                    description: recruitment.title,
                                    recruitmentId: recruitment.id,
                                    isBookmarked: recruitment.isBookmarked,
                                    onBookmarkToggled: {
                                        viewModel.onAction(.toggleBookmark(recruitment.id))
                                    }
                                )
                                .onAppear {
                                    // 最後から2番目のアイテムが表示された時に追加読み込みを開始
                                    if index >= viewModel.uiState.recruitments.count - 2 {
                                        viewModel.onAction(.loadMore)
                                    }
                                }
                            }
                            
                            if viewModel.uiState.isLoadingMore {
                                LoadingRecruitmentCardView()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .id(RecruitmentsConstants.top)
                    }
                    .navigationTitle("recruitments")
                    .navigationBarTitleDisplayMode(.large)
                    .searchable(
                        text: Binding(
                            get: { viewModel.uiState.searchText },
                            set: { viewModel.onAction(.onSearchTextChanged($0)) }
                        ),
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "search_keyword"
                    )
                    .onSubmit(of: .search) {
                        viewModel.onAction(.search)
                        scrollToTop = true
                    }
                    .focused($isSearchFocused)
                    .onTapGesture {
                        isSearchFocused = false
                    }
                    .onAppear {
                        viewModel.onAction(.onAppear)
                    }
                    .onChange(of: scrollToTop) { _, shouldScroll in
                        if shouldScroll {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo(RecruitmentsConstants.top, anchor: .top)
                            }
                            scrollToTop = false
                        }
                    }
                }
                
                if viewModel.uiState.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .wantedlyBlue))
                }
            }
        }
    }
}

#Preview {
    RecruitmentsScreen()
}
