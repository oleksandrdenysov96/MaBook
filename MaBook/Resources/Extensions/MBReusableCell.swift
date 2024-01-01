//
//  MBReusableCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 31.12.2023.
//

import Foundation
import UIKit

protocol MBReusableCell {
    static var cellIdentifier: String { get }
}


extension MBReusableCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: MBReusableCell {
        register(T.self, forCellWithReuseIdentifier: T.cellIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: MBReusableCell {
        register(T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            MBLogger.shared.debugInfo(
                "reuse cell error - unable to dequeue cell ** \(T.cellIdentifier) **"
            )
            fatalError()
        }
        return cell
    }
}
