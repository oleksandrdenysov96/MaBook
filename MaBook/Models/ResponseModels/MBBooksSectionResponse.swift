//
//  MBBooksSectionResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 29.12.2023.
//

import Foundation


struct MBBooksSectionResponse: Codable {
    let status: Int
    let message: String
    let data: BooksData
}
