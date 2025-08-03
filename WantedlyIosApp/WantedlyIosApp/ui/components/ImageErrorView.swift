import SwiftUI

struct ImageErrorView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    Text("image_load_error")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            )
    }
}

#Preview {
    ImageErrorView()
        .frame(width: 200, height: 100)
        .padding()
}
