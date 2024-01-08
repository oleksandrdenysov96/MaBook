//
//  MBSearchBookDetailsResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 06.01.2024.
//

import Foundation


struct MBSearchBookDetailsResponse: Codable {
    let status: Int
    let message: String
    let data: BookSearchData
}

struct BookSearchData: Codable {
    let books: [Books]
}
