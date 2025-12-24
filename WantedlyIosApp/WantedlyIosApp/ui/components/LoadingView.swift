//
//  LoadingView.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/12/21.
//
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(1.5)
            .progressViewStyle(CircularProgressViewStyle(tint: .wantedlyBlue))
    }
}

#Preview {
    LoadingView()
}
