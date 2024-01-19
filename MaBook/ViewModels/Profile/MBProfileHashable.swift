//
//  MBProfileHashable.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 16.01.2024.
//

import Foundation

protocol MBProfileReusable {
    var title: String { get }
}

protocol MBProfileHashable: MBProfileReusable, Hashable { }

extension MBProfileHashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}


struct AnyProfileCell: Hashable {
    let base: any MBProfileHashable

    init(_ base: any MBProfileHashable) {
        self.base = base
    }
    
    static func == (lhs: AnyProfileCell, rhs: AnyProfileCell) -> Bool {
        lhs.base.title == rhs.base.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
}
