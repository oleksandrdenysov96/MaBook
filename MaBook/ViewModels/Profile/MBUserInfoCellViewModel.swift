//
//  MBUserInfoCellViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 16.01.2024.
//

import Foundation


struct MBUserInfoCellViewModel: MBProfileHashable {
    var title: String
    let id: String
    let image: String?
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.title == rhs.title
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(title)
//    }
}
