//
//  MBBookListCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 29.12.2023.
//

import UIKit

class MBBookListCollectionViewCell: MBBookCollectionViewCell {
    
    override class var cellIdentifier: String {
        "MBDetailsListBookCollectionViewCell"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonSubviews()
        contentView.addSubview(addToCartButton)
        super.setupConstraints()
        setupConstraintsForListCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraintsForListCell() {
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: genreView.bottomAnchor, constant: 15),
            addToCartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}
