import SwiftUI

enum RecruitmentsIntent {
    case onAppear
    case onSearchTextChanged(String)
}

struct RecruitmentsScreen: View {
    @StateObject private var viewModel = RecruitmentsViewModel()
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<10, id: \.self) { index in
                            RecruitmentCard(
                                companyLogoURL: "https://via.placeholder.com/24x24",
                                companyName: "株式会社サンプル\(index + 1)",
                                thumbnailURL: "https://via.placeholder.com/400x200",
                                description: "私たちは革新的なテクノロジーで社会に貢献する企業です。優秀な人材と共に、未来を創造していきましょう。"
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
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
                .focused($isSearchFocused)
                .onTapGesture {
                    isSearchFocused = false
                }
                .onAppear {
                    viewModel.onAction(.onAppear)
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
