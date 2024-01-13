//
//  MBCartView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 08.01.2024.
//

import UIKit

protocol MBCartViewDelegate: AnyObject {
    func mbCartView(needsSetup collection: UICollectionView)
}

class MBCartView: UIView {

    public weak var delegate: MBCartViewDelegate?

    private let summarySectionView = MBCartSummarySectionView()

    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(views: summarySectionView, collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public func configureSummarySection(itemPrice: String, shipmentFee: String, totalPrice: String) {
        summarySectionView.configureLabels(
            itemsPriceValue: itemPrice,
            shipmentFee: shipmentFee,
            totalPrice: totalPrice
        )
    }

    public func updateTotalSumWith(newPrice price: String) {
        summarySectionView.updateTotal(newSum: price)
    }

    public func setupCollection() {
        delegate?.mbCartView(needsSetup: collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            summarySectionView.heightAnchor.constraint(equalToConstant: 270),
            summarySectionView.widthAnchor.constraint(equalTo: widthAnchor),
            summarySectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: summarySectionView.topAnchor, constant: -15)
        ])
    }

}
