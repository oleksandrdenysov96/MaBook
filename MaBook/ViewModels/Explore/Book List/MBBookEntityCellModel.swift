//
//  MBBookEntityCellModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 02.02.2024.
//

import Foundation


struct MBBookEntityCellModel: Hashable {
    let identifier: UUID
//    let title: String
//    let price: String
//    let genre: String
//    let bookImage: String?
//    let view: Int
//    let createdAt: String
    var book: Book
}
