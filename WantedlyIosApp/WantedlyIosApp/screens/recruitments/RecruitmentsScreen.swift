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
                        ForEach(viewModel.uiState.recruitments, id: \.id) { recruitment in
                            RecruitmentCardView(
                                companyLogoURL: recruitment.companyLogoImage ?? "",
                                companyName: recruitment.companyName,
                                thumbnailURL: recruitment.thumbnailUrl,
                                description: recruitment.title
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
