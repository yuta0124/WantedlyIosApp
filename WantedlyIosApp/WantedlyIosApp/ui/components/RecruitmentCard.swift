import SwiftUI

struct RecruitmentCard: View {
    let companyLogoURL: String
    let companyName: String
    let thumbnailURL: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RecruitmentCardHeader(
                companyLogoURL: companyLogoURL,
                companyName: companyName
            )
    
            AsyncImage(url: URL(string: thumbnailURL)) { phase in
                switch phase {
                case .empty:
                    Shimmer()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    ImageError()
                @unknown default:
                    ImagePlaceholder()
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(16/9, contentMode: .fit)
            .clipped()
            
            Text(description)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    RecruitmentCard(
        companyLogoURL: "https://via.placeholder.com/24x24",
        companyName: "株式会社サンプル",
        thumbnailURL: "https://via.placeholder.com/400x200",
        description: "私たちは革新的なテクノロジーで社会に貢献する企業です。優秀な人材と共に、未来を創造していきましょう。"
    )
    .padding()
} 
