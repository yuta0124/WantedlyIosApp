//
//  RecruitmentDetailResponse.swift
//  WantedlyIosApp
//
//  Created by 佐藤優太 on 2025/11/15.
//

struct RecruitmentDetailResponse: Codable {
    let data: RecruitmentDetailData
}

struct RecruitmentDetailData: Codable {
    let id: Int
    let title: String
    let image: ImageData
    let company: Company
    let whatDescription: String
    let whyDescription: String
    let howDescription: String
}
