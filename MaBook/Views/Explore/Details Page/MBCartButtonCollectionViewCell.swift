//
//  MBCartButtonViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.01.2024.
//

import UIKit
import Combine

class MBCartButtonCollectionViewCell: UICollectionViewCell, MBReusableCell {

    public private (set) var tapCartButtonSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()


    private let addToCartButton: MBButton = {
        return MBButton(title: "Configuring price...")
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(addToCartButton)
        addToCartButton.isLoading = true

        addToCartButton.addTarget(
            self,
            action: #selector(didTapAddToCart),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            addToCartButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    public func configure(pointValue: String, currencyValue: String, inCart: Bool) {
        DispatchQueue.main.async { [unowned self] in
            if inCart {
                self.addToCartButton.updateInCartState(to: true)
            }
            else {
                addToCartButton.setTitle(
                    "Add to Cart (\(pointValue)P | \(String(currencyValue)))",
                    for: .normal
                )
            }
            addToCartButton.isLoading = false
        }
    }

    public func updateButtonState(to state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.addToCartButton.updateInCartState(to: state)
        }
    }

    @objc private func didTapAddToCart() {
        tapCartButtonSubject.send()
    }
}
