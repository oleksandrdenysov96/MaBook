//
//  MBSearchBookDetailsResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 06.01.2024.
//

import Foundation

// MARK: For Search && Basket

struct MBRequestedBooksResponse: Codable {
    let status: Int
    let message: String
    let data: RequestedBooksData
}

struct RequestedBooksData: Codable {
    let books: [Book]
}
