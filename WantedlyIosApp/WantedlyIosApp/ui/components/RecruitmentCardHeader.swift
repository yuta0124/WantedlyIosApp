import SwiftUI

struct RecruitmentCardHeader: View {
    let companyLogoURL: String
    let companyName: String
    @State private var isBookmarked = false
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: companyLogoURL)) { phase in
                switch phase {
                case .empty:
                    Shimmer()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    ImagePlaceholder()
                @unknown default:
                    ImagePlaceholder()
                }
            }
            .frame(width: 24, height: 24)
            .cornerRadius(4)
            
            Text(companyName)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button {
                isBookmarked.toggle()
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
    RecruitmentCardHeader(
        companyLogoURL: "https://via.placeholder.com/24x24",
        companyName: "株式会社サンプル"
    )
    .padding()
}
