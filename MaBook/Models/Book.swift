//
//  Book.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import Foundation


struct Book: Codable, Hashable {
    let id, userId: Int
    let title, description, author: String
    let images: [String]
    let price: String
    let category, genre, condition: String
    let pages: Int
    let dimensions, status: String
    let view: Int
    let isFavorite: Bool
    let createdAt: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(createdAt)
        hasher.combine(title)
    }
}

struct Info: Codable {
    let currentPage, nextPage: String?
}
