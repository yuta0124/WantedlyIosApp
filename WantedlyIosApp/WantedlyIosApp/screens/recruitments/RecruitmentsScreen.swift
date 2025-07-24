import SwiftUI

struct RecruitmentsScreen: View {
    @StateObject private var viewModel = RecruitmentsViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("recruitments_screen_content")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .navigationTitle("recruitments")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    RecruitmentsScreen()
}
