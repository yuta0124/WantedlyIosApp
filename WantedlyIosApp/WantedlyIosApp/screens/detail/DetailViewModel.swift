//
//  DetailViewModel.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/11.
//
import Combine
import Foundation
import SwiftUI

// TODO: ブックマーク
@MainActor
class DetailViewModel: ObservableObject {
    private let wantedlyRepository: WantedlyRepository
    
    // MARK: UIState
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var recruitmentId: Int
    @Published private(set) var title: String = ""
    @Published private(set) var companyName: String = ""
    @Published private(set) var thumbnailUrl: String = ""
    @Published private(set) var isBookmarked: Bool = false
    @Published private(set) var companyLogoImage: String = ""
    @Published private(set) var whatDescription: String = ""
    @Published private(set) var whyDescription: String = ""
    @Published private(set) var howDescription: String = ""
    
    init(
        recruitmentId: Int,
        wantedlyRepository: WantedlyRepository = DefaultWantedlyRepository()
    ) {
        self.recruitmentId = recruitmentId
        self.wantedlyRepository = wantedlyRepository
        
        Task {
            await fetchRecruitmentDetail()
        }
    }
    
    private func fetchRecruitmentDetail() async {
        let result = await wantedlyRepository.fetchRecruitmentDetail(self.recruitmentId)
        
        switch result {
        case .success(let response):
            onSuccess(response.data)
            
        case .failure(let error):
            print("詳細取得エラー: \(error.localizedDescription)")
            // TODO: エラーハンドリング
        }
        
        self.isLoading = false
    }
    
    // TODO: bookmarkはdbを元に更新する
    private func onSuccess(_ response: RecruitmentDetailData) {
        self.title = response.title
        self.companyName = response.company.name
        self.thumbnailUrl = response.image.original
//        self.isBookmarked =
        self.companyLogoImage = response.company.avatar?.original ?? ""
        self.whatDescription = response.whatDescription
        self.whyDescription = response.whyDescription
        self.howDescription = response.howDescription
    }
    
    func onBookmarkToggle() {
        // TODO: ブックマーク切り替え
    }
}
