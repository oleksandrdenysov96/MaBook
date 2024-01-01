//
//  MBBookDetailsView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 30.12.2023.
//

import UIKit

protocol MBBookDetailsViewDelegate: AnyObject {
    func mbBookDetailsView(_ detailsView: MBBookDetailsView, needsConfigure button: MBButton)
    func mbBookDetailsView(
        _ detailsView: MBBookDetailsView, needsConfigure collection: UICollectionView
    )
}

class MBBookDetailsView: UIView {

    public weak var delegate: MBBookDetailsViewDelegate?

    private let collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    private let addToCartButton: MBButton = {
        return MBButton(title: "Configuring price...")
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(addToCartButton)
        setupConstraints()
        addToCartButton.isLoading = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureCartButtonPrice() {
        delegate?.mbBookDetailsView(self, needsConfigure: addToCartButton)
    }

    public func configureCollectionView() {
        delegate?.mbBookDetailsView(self, needsConfigure: collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -20),

            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            addToCartButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
