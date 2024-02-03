//
//  MBExploreView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import UIKit

protocol MBExploreViewDelegate: AnyObject {
    func mbExploreViewNeedConfigure(
        collectionView: UICollectionView,
        _ completion: @escaping () -> Void
    )

    func mbExploreViewNeedUpdate(
        _ collection: UICollectionView,
        _ completion: @escaping (Bool) -> Void
    )
}

class MBExploreView: UIView, MBCartProvider {

    public weak var delegate: MBExploreViewDelegate?

    var floatingButton: MBFloatingCartButton = {
        let button = MBFloatingCartButton(frame: .zero)
        button.isHidden = false
        button.alpha = 1
        return button
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
        setupSelfConstraints()
        
        setupCartButton()
        setupCartConstraints()
        floatingButton.isHidden = true
        floatingButton.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureCollectionView() {
        delegate?.mbExploreViewNeedConfigure(
            collectionView: collectionView
        ) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.floatingButton.isHidden = false
                self?.floatingButton.alpha = 1
            }
        }
    }

    public func updateCollectionView(_ completion: @escaping (Bool) -> Void) {
        delegate?.mbExploreViewNeedUpdate(collectionView) { result in
            completion(result)
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

    func applyCartSelector(_ selector: Selector) {
        floatingButton.addTarget(
            self,
            action: selector,
            for: .touchUpInside
        )
    }
}
