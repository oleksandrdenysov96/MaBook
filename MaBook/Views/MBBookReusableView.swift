//
//  MBBookReusableView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 08.01.2024.
//

import UIKit

class MBBookReusableView: UIView {

    internal let floatingButton: MBFloatingCartButton = {
        let button = MBFloatingCartButton(frame: .zero)
        button.isHidden = false
        button.alpha = 1
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setupCartButton() {
        addSubview(floatingButton)
    }

    internal func setupConstraints() {
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
