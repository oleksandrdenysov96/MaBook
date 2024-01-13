//
//  MBSeparator.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 08.01.2024.
//

import UIKit

class MBSeparator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        setSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func setSize(width: CGFloat = 360) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
