//
//  MBEndpoint.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation

enum MBEndpoint: String, CaseIterable {
    case auth = "auth"
    case user = "user"
    case books = "books"
    case category = "category"
    case all = "all"
    case recently = "recently"
    case popular = "popular"
}
