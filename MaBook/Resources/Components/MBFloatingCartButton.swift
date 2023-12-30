//
//  MBFloatingCartButton.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import UIKit

class MBFloatingCartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setImage(UIImage(named: "cart"), for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        translatesAutoresizingMaskIntoConstraints = false

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
