//
//  MBCategoriesListView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 29.12.2023.
//

import UIKit

protocol MBCategoriesListViewDelegate: AnyObject {
    func mbCategoriesListView(
        _ listView: MBCategoriesListView,
        needsSetup collection: UICollectionView
    )
}

class MBCategoriesListView: UIView, MBCartProvider {

    public weak var delegate: MBCategoriesListViewDelegate?

    var floatingButton: MBFloatingCartButton = {
        let button = MBFloatingCartButton(frame: .zero)
        button.isHidden = false
        button.alpha = 1
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: 0, left: 8, bottom: 12, right: 8
        )
        layout.minimumInteritemSpacing = -5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubview(collectionView)
        setupCartButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        setupCartProvideableConstraints()
        setupSelfConstraints()
        setupCartConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupCollectionView() {
        delegate?.mbCategoriesListView(self, needsSetup: collectionView)
    }

    private func setupSelfConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
