//
//  MBBooksHomeResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import Foundation

struct MBBooksHomeResponse: Codable {
    let status: Int
    let message: String
    let data: AllData
}


struct AllData: Codable {
    let categories: [Categories]
    let allBooks: BooksData
    let recentlyAdded: BooksData
    let mostViewed: BooksData
}

public struct Categories: Codable {
    let name: String
    let image: String
    let count: Int
}

public struct BooksData: Codable {
    let books: [Books]
    let info: Info
}

