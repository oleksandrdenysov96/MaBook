//
//  User.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation

public struct User: Codable, Hashable {
    
    let id: Int
    let name, lastName, email: String
    let points: Int
    let avatar, location, language: String
    let address: String?
    let isOnboarding: Bool
    let storage: [Storage]?
    let basket: Int
    var historySearches: [[String: String]]?
    let createdAt, updatedAt: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(createdAt)
        hasher.combine(email)
        hasher.combine(name)
    }
}


struct Storage: Codable, Hashable {
    let title, author, fullName, id: String
}
