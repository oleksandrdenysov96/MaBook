//
//  MBCartProvideable.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.01.2024.
//

import UIKit
import Foundation


protocol MBCartProvidingViewDelegate: AnyObject {
    func mbCartProvidingViewDidTapCartButton()
}

protocol MBCartProvideable {
    var floatingButton: MBFloatingCartButton { get set }
    func setupCartButton()
    func setupCartProvideableConstraints()
}

extension MBCartProvideable where Self: UIView {

    func setupCartButton() {
        addSubview(floatingButton)
        self.setupCartProvideableConstraints()
    }

    func setupCartProvideableConstraints() {
        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        floatingButton.layer.cornerRadius = 30
        floatingButton.layer.shadowRadius = 10
    }
}
