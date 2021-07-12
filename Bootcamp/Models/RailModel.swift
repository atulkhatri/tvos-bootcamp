//
//  RailModel.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import Foundation

struct RailModel: Codable {
    let title, type: String
    let list: [AssetModel]
}
