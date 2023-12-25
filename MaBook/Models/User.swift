//
//  User.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation

public struct User: Codable {
    let id, name, lastName, email: String
    let password, points, avatar, location: String
    let language, address: String
    let isUnboarding: Bool
    let storage, favorites, basket, recentSearches: [String]
    let userBooks: [String]
    let createdAt, updatedAt: String
}
