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

class MBExploreView: MBCartProvidingView {

    public weak var delegate: MBExploreViewDelegate?

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(
            views:
            collectionView
        )
        setupCartButton()
        setupConstraints()
        setupSelfConstraints()
        floatingButton.isHidden = true
        floatingButton.alpha = 0
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
                self?.floatingButton.alpha = 1
            }
        }
    }

    private func setupSelfConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }
}
