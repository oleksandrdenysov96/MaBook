//
//  MBOnboardingResponse.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 24.12.2023.
//

import Foundation

struct MBOnboardingResponse: Codable {
    let status: Int
    let message: String
    let data: LocationsData
}

struct LocationsData: Codable {
    let languages: [String: [String]]
    let countries: [String: [String]]
    let onboardingImage: String
}
