import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            RecruitmentsScreen()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("recruitments")
                }
            BookmarkScreen()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("bookmarks")
                }
        }
        .accentColor(.primaryBlue)
    }
}

#Preview {
    MainTabView()
}
