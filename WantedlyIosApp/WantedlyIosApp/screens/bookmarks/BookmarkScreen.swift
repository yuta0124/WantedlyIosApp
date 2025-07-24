import SwiftUI

struct BookmarkScreen: View {
    @StateObject private var viewModel = BookmarkViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("bookmark_screen_content")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .navigationTitle("bookmarks")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    BookmarkScreen()
}
