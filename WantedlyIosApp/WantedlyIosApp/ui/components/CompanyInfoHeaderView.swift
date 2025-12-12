import SwiftUI

struct CompanyInfoHeaderView: View {
    let companyLogoURL: String
    let companyName: String
    let recruitmentId: Int
    let isBookmarked: Bool
    let onBookmarkToggled: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImageView(url: URL(string: companyLogoURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ShimmerView()
            }
            .frame(width: 24, height: 24)
            .cornerRadius(4)
            
            Text(companyName)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button {
                onBookmarkToggled()
            } label: {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(isBookmarked ? .wantedlyBlue : .gray)
                    .font(.system(size: 16))
            }
            .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    CompanyInfoHeaderView(
        companyLogoURL: "https://via.placeholder.com/24x24",
        companyName: "株式会社サンプル",
        recruitmentId: 1,
        isBookmarked: false,
        onBookmarkToggled: { }
    )
    .padding()
}
