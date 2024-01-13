//
//  MBBookDetailsResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 01.01.2024.
//

import Foundation


struct MBBookDetailsResponse: Codable {
    let status: Int
    let message: String
    let data: Book
}
