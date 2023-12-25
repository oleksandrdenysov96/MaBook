//
//  MBAuthResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation

struct MBAuthResponse: Codable {
    let status: Int
    let message: String
    let accessToken: String
}
