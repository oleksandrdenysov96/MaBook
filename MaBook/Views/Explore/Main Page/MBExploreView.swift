//
//  MBExploreView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import UIKit

protocol MBExploreViewDelegate: AnyObject {
    func mbExploreViewNeedConfigureCollectionView(
        _ exploreView: MBExploreView,
        collectionView: UICollectionView,
        _ completion: @escaping () -> Void
    )
}

class MBExploreView: UIView {

    public weak var delegate: MBExploreViewDelegate?

    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Book name or writer name"
        searchBar.isHidden = true
        searchBar.alpha = 0
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.backgroundColor = .clear
        collectionView.register(
            MBCategoriesCollectionViewCell.self,
            forCellWithReuseIdentifier: 
                MBCategoriesCollectionViewCell
                .cellIdentifier
        )
        collectionView.register(
            MBBookCollectionViewCell.self,
            forCellWithReuseIdentifier: 
                MBBookCollectionViewCell
                .cellIdentifier
        )
        collectionView.register(
            MBExploreSectionCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: MBExploreSectionCollectionReusableView
                .identifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let floatingButton: MBFloatingCartButton = {
        let button = MBFloatingCartButton(frame: .zero)
        button.isHidden = true
        button.alpha = 0
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(
            views: searchBar,
            collectionView,
            floatingButton
        )
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureCollectionView() {
        delegate?.mbExploreViewNeedConfigureCollectionView(
            self, collectionView: collectionView
        ) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.floatingButton.isHidden = false
                self?.searchBar.isHidden = false
                self?.floatingButton.alpha = 1
                self?.searchBar.alpha = 1
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            searchBar.heightAnchor.constraint(equalToConstant: 70),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])

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
