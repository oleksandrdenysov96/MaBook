//
//  MBCartSummarySectionView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 08.01.2024.
//

import UIKit

class MBCartSummarySectionView: UIView {

    private let checkoutButton: MBButton = {
        return MBButton(title: "Proceed to Checkout")
    }()

    private lazy var itemsPrice: UILabel = {
        return self.textLabel(isTitle: true)
    }()

    private lazy var shipmentFeeLabel: UILabel = {
        return self.textLabel(isTitle: true)
    }()

    private lazy var totalPriceLabel: UILabel = {
        return self.textLabel(isTitle: true)
    }()

    private lazy var itemPriceValue: UILabel = {
        return self.textLabel(isTitle: false)
    }()

    private lazy var shipmentValue: UILabel = {
        return self.textLabel(isTitle: false)
    }()

    private lazy var totalPriceValue: UILabel = {
        return self.textLabel(isTitle: true)
    }()

    private let separator: MBSeparator = {
        return MBSeparator()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(
            red: 0.93, green: 0.95, blue: 0.95, alpha: 1
        )
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(
            views:
                itemsPrice,
            shipmentFeeLabel,
            separator,
            totalPriceLabel,
            itemPriceValue,
            shipmentValue,
            totalPriceValue,
            checkoutButton
        )
        setupConstraints()
    }

    private func textLabel(isTitle: Bool) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(
            red: 0.243, green: 0.286, blue: 0.29, alpha: 1
        )
        label.textAlignment = .left

        if isTitle {
            label.font = UIFont(
                name: "HelveticaNeue-Bold", size: 16
            )
        }
        else {
            label.font = UIFont(
                name: "HelveticaNeue", size: 15
            )
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureLabels(itemsPriceValue: String, shipmentFee: String, totalPrice: String) {
        itemsPrice.text = "Item Value"
        shipmentFeeLabel.text = "Shipment Fee"
        totalPriceLabel.text = "Total"

        itemPriceValue.text = itemsPriceValue
        shipmentValue.text = shipmentFee
        totalPriceValue.text = totalPrice
    }

    public func updateTotal(newSum: String) {
        totalPriceValue.text = newSum
        itemPriceValue.text = newSum
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkoutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -55),
            checkoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            itemsPrice.leftAnchor.constraint(equalTo: checkoutButton.leftAnchor),
            itemsPrice.topAnchor.constraint(equalTo: topAnchor, constant: 35),

            shipmentFeeLabel.topAnchor.constraint(equalTo: itemsPrice.bottomAnchor, constant: 10),
            shipmentFeeLabel.leftAnchor.constraint(equalTo: checkoutButton.leftAnchor),

            separator.topAnchor.constraint(equalTo: shipmentFeeLabel.bottomAnchor, constant: 25),
            separator.centerXAnchor.constraint(equalTo: centerXAnchor),

            totalPriceLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            totalPriceLabel.leftAnchor.constraint(equalTo: checkoutButton.leftAnchor),
        ])

        NSLayoutConstraint.activate([
            itemPriceValue.leftAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            itemPriceValue.topAnchor.constraint(equalTo: topAnchor, constant: 35),

            shipmentValue.leftAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            shipmentValue.topAnchor.constraint(equalTo: itemPriceValue.bottomAnchor, constant: 10),

            totalPriceValue.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            totalPriceValue.leftAnchor.constraint(equalTo: centerXAnchor, constant: 10)
        ])
    }

}
