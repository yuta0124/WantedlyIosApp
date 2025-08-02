import SwiftUI

struct ImagePlaceholder: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
    }
}

#Preview {
    ImagePlaceholder()
        .frame(width: 200, height: 100)
        .padding()
}
