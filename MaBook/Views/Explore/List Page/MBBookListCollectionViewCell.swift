//
//  MBBookListCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 29.12.2023.
//

import UIKit

protocol MBBookListCollectionViewCellDelegate: AnyObject {
    func mbBookListCollectionViewCellDidTapAddToCart(on cell: MBBookListCollectionViewCell)
}

class MBBookListCollectionViewCell: MBBookCollectionViewCell {

    public weak var delegate: MBBookListCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonSubviews()
        contentView.addSubview(addToCartButton)
        
        super.imageView.layer.cornerRadius = 10
        super.setupConstraints()
        setupConstraintsForListCell()

        addToCartButton.addTarget(
            self, action: #selector(didTapAddToCart), for: .touchUpInside
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapAddToCart() {
        delegate?.mbBookListCollectionViewCellDidTapAddToCart(on: self)
    }

    private func setupConstraintsForListCell() {
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: genreView.bottomAnchor, constant: 15),
            addToCartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}
