//
//  DetailDescriptionSection.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/12/12.
//

import SwiftUI

struct DetailDescriptionSection: View {
    let title: String
    let description: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .background(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.accentColor.opacity(0.3))
                            .frame(height: geometry.size.height * 0.4)
                            .offset(y: geometry.size.height * 0.6)
                    }
                )
            
            Text(description ?? "no_data")
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    DetailDescriptionSection(
        title: "タイトルサンプル",
        description: "サンプルの説明文です。ここに詳細な情報が入ります。サンプルの説明文です。サンプルの説明文です。サンプルの説明文です。"
    )
}
