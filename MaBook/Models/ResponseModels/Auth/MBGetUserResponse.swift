//
//  MBGetUserResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 27.12.2023.
//

import Foundation

struct MBGetUserResponse: Codable {
    let status: Int
    let message: String
    let data: UserData
}

struct UserData: Codable {
    let user: User
}
