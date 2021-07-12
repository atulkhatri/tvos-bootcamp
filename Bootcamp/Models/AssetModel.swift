//
//  AssetModel.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import Foundation

struct AssetModel: Codable {
    let id: Int
    let title, summary: String
    let rating: Double
    let image, backdrop: String
    let type: AssetType
    let url: String
}

enum AssetType: String, Codable {
    case movie = "movie"
    case series = "series"
}
