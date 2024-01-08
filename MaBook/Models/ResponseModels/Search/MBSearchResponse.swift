//
//  MBSearchResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 06.01.2024.
//

import Foundation


struct MBSearchResponse: Codable {
    let status: Int
    let message: String
    let data: SearchData
}

struct SearchData: Codable {
    let searchResult: [MatchedBook]
}

struct MatchedBook: Codable {
    let id: Int
    let title: String
    let author: String
}
