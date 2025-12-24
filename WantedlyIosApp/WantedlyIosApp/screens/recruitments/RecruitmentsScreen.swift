//
//  RecruitmentsScreen.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/11.
//
import SwiftUI

struct RecruitmentsScreen: View {
    @State private var viewModel = RecruitmentsViewModel()
    @State private var scrollToTop = false
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.recruitments.enumerated()), id: \.element.id) { index, recruitment in
                                NavigationLink(value: recruitment.id) {
                                    RecruitmentCardView(
                                        companyLogoURL: recruitment.companyLogoImage,
                                        companyName: recruitment.companyName,
                                        thumbnailURL: recruitment.thumbnailUrl,
                                        description: recruitment.title,
                                        recruitmentId: recruitment.id,
                                        isBookmarked: recruitment.isBookmarked,
                                        onBookmarkToggled: {
                                            viewModel.onBookmarkToggled(for: recruitment.id)
                                        }
                                    )
                                }
                                .onAppear {
                                    // 最後から2番目のアイテムが表示された時に追加読み込みを開始
                                    if index >= viewModel.recruitments.count - 2 {
                                        viewModel.loadMore()
                                    }
                                }
                            }
                            
                            if viewModel.isLoadingMore {
                                LoadingRecruitmentCardView()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .id(RecruitmentsConstants.top)
                    }
                    .navigationTitle("recruitments")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationDestination(for: Int.self) { recruitmentId in
                        DetailScreen(recruitmentId: recruitmentId)
                    }
                    .searchable(
                        text: Binding(
                            get: { viewModel.searchText },
                            set: { viewModel.onSearchTextChanged($0) }
                        ),
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "search_keyword"
                    )
                    .onSubmit(of: .search) {
                        viewModel.onSearch()
                        scrollToTop = true
                    }
                    .focused($isSearchFocused)
                    .onTapGesture {
                        isSearchFocused = false
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
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
        }
    }
}

#Preview {
    RecruitmentsScreen()
}
