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

    override func prepareForReuse() {
        super.prepareForReuse()
        addToCartButton.titleLabel?.text = nil
        imageView.image = nil
        cellBookTitle.text = nil
        genreLabel.text = nil
        priceLabel.text = nil
    }

    @objc private func didTapAddToCart() {
        delegate?.mbBookListCollectionViewCellDidTapAddToCart(on: self)
    }

    override public func configure(with model: Book, withBadge badge: CellBadgeType) {
        super.configure(with: model, withBadge: badge)

        DispatchQueue.main.async {
//            self.addToCartButton.setTitle(
//                model.isAddedToCart ? "In Cart" : "Add to Cart",
//                for: .normal
//            )
            if model.isAddedToCart {
                self.addToCartButton.setSelected()
                self.addToCartButton.setTitle(
                    "In Cart", for: .normal
                )
            }
        }

    }

    private func setupConstraintsForListCell() {
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: genreView.bottomAnchor, constant: 15),
            addToCartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
//
//    public func updateCartButton() {
//        DispatchQueue.main.async { [weak self] in
//            self?.addToCartButton.setTitle("In cart", for: .normal)
//        }
//    }
}
