import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.3),
                            Color.gray.opacity(0.1),
                            Color.gray.opacity(0.3)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color.white.opacity(0.6),
                                    Color.clear
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(100))
                        .offset(x: isAnimating ? geometry.size.width + 100 : -geometry.size.width - 100)
                        .animation(
                            .linear(duration: 1.0)
                            .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                )
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

#Preview {
    ShimmerView()
        .frame(width: 200, height: 100)
        .padding()
}
