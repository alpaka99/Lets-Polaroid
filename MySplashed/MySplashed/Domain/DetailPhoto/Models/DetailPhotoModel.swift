//
//  DetailPhotoModel.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

struct DetailPhotoModel: Equatable {
    let photographerData: PhotographerData?
    let imageData: UnsplashImageData?
    let statisticsData: StatisticsData?
}

struct StatisticsData: Equatable, Decodable {
    let id: String
    let downloads: DownloadsData
    let views: ViewsData
}

struct DownloadsData: Equatable, Decodable {
    let total: Int
    let historical: HistoricalData
}

struct ViewsData: Equatable, Decodable {
    let total: Int
    let historical: HistoricalData
}

struct HistoricalData: Equatable, Decodable {
    let values: [ValuesData]
}

struct ValuesData: Equatable, Decodable {
    let date: String
    let value: Int
}
