import SwiftUI

struct LoadingRecruitmentCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                CompanyLogoShimmerView()
                CompanyNameShimmerView()
                Spacer()
                BookmarkButtonShimmerView()
            }
            
            ThumbnailShimmerView()
            DescriptionShimmerView()
        }
    }
}

private struct CompanyLogoShimmerView: View {
    var body: some View {
        ShimmerView()
            .frame(width: 24, height: 24)
            .cornerRadius(4)
    }
}

private struct CompanyNameShimmerView: View {
    var body: some View {
        ShimmerView()
            .frame(width: 120, height: 14)
    }
}

private struct BookmarkButtonShimmerView: View {
    var body: some View {
        ShimmerView()
            .frame(width: 24, height: 24)
    }
}

private struct ThumbnailShimmerView: View {
    var body: some View {
        ShimmerView()
            .frame(maxWidth: .infinity)
            .aspectRatio(16/9, contentMode: .fit)
            .clipped()
    }
}

private struct DescriptionShimmerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
            }
        }
    }
}

#Preview {
    LoadingRecruitmentCardView()
        .padding()
}
