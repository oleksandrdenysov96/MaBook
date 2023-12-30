//
//  Books.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import Foundation


struct Books: Codable {
    let id, userId: Int
    let title, description, author: String
    let images: [String]
    let price: Double
    let category, genre, condition: String
    let pages: Int
    let dimensions, status: String
    let view: Int
    let isFavorite: Bool
    let createdAt: String
}

struct Info: Codable {
    let currentPage, nextPage: String?
}
