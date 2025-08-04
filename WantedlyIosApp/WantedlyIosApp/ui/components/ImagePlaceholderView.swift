import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
    }
}

#Preview {
    ImagePlaceholderView()
        .frame(width: 200, height: 100)
        .padding()
}
