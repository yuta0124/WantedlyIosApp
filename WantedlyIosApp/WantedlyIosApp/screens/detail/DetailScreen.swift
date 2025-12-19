//
//  DetailScreen.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/11.
//
import SwiftUI

struct DetailScreen: View {
    @State private var viewModel: DetailViewModel
    @State private var scrollOffset: CGFloat = 0
    
    init(recruitmentId: Int) {
        _viewModel = State(wrappedValue: DetailViewModel(recruitmentId: recruitmentId))
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    CachedAsyncImageView(url: URL(string: viewModel.thumbnailUrl)) { thumbnail in
                        thumbnail.resizable()
                    } placeholder: {
                        ShimmerView()
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16/9, contentMode: .fit)
                    .stretchy()
                    
                    VStack(spacing: 12) {
                        CompanyInfoHeaderView(
                            companyLogoURL: viewModel.companyLogoImage,
                            companyName: viewModel.companyName,
                            recruitmentId: viewModel.recruitmentId,
                            isBookmarked: viewModel.isBookmarked,
                            onBookmarkToggled: {
                                viewModel.onBookmarkToggle()
                            }
                        )
                        Text(viewModel.title.isEmpty ? "---" : viewModel.title)
                            .font(.system(size: 22, weight: .regular))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                        
                        WhatDescriptionSection(description: viewModel.whatDescription)
                        .frame(maxWidth: .infinity)
                        
                        WhyDescriptionSection(description: viewModel.whyDescription)
                        .frame(maxWidth: .infinity)
                        
                        HowDescriptionSection(description: viewModel.howDescription)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, proxy.safeAreaInsets.bottom)
                }
                .background {
                    GeometryReader { contentProxy in
                        Color.clear.onChange(of: contentProxy.frame(in: .named("ScrollView")).minY) { _, offset in
                            self.scrollOffset = offset
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .overlay(alignment: .top) {
                if scrollOffset < 0 {
                    Color(.systemBackground)
                        .opacity(0.5)
                        .frame(height: proxy.safeAreaInsets.top)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

private struct WhatDescriptionSection: View {
    let description: String
    
    var body: some View {
        DetailDescriptionSection(
            title: "What?",
            description: description
        )
    }
}

private struct WhyDescriptionSection: View {
    let description: String
    
    var body: some View {
        DetailDescriptionSection(
            title: "Why?",
            description: description
        )
    }
}

private struct HowDescriptionSection: View {
    let description: String
    
    var body: some View {
        DetailDescriptionSection(
            title: "How?",
            description: description
        )
    }
}

#Preview  {
    DetailScreen(recruitmentId: 1)
}
