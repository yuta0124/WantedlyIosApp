//
//  BookmarkScreen.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/11.
//
import SwiftUI

struct BookmarkScreen: View {
    @State private var viewModel = BookmarkViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.recruitments {
                case .none:
                    LoadingView()
                case .some(let recruitments) where recruitments.isEmpty:
                    EmptyView()
                case .some(let recruitments):
                    BookmarkListView(
                        recruitments: recruitments,
                        onBookmarkToggled: { id in
                            viewModel.onBookmarkToggled(id)
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

private struct BookmarkListView: View {
    let recruitments: [Recruitment]
    let onBookmarkToggled: (Int) -> Void
    
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
                                onBookmarkToggled(recruitment.id)
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

private struct EmptyView: View {
    var body: some View {
        Text("ブックマークがありません")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.gray.opacity(0.6))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BookmarkScreen()
}
