//
//  MBBooksListView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 29.12.2023.
//

import UIKit

protocol MBBooksListViewDelegate: AnyObject {
    func mbBooksListView(
        _ listView: MBBooksListView, needsConfigure collection: UICollectionView
    )
    func mbBooksListView(
        _ listView: MBBooksListView, needsUpdate collection: UICollectionView
    )
    func mbBooksListView(_ listView: MBBooksListView, needsSort collection: UICollectionView)
    func mbBooksListViewShouldShowFilters(updateOnCompletion collection: UICollectionView)
}

final class MBBooksListView: UIView {

    public weak var delegate: MBBooksListViewDelegate?

    private let sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sort", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        return button
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Filter", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: 0, left: 10, bottom: 10, right: 10
        )
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        collectionView.register(
            MBBookListCollectionViewCell.self,
            forCellWithReuseIdentifier:
                MBBookListCollectionViewCell.cellIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubviews(
            views: sortButton,
            filterButton,
            collectionView
        )
        addTargets()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureCollectionView() {
        delegate?.mbBooksListView(self, needsConfigure: collectionView)
    }

    public func updateCollectionView() {
        delegate?.mbBooksListView(self, needsUpdate: collectionView)
    }

    private func addTargets() {
        sortButton.addTarget(self, action: #selector(didTapSort), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
    }

    @objc private func didTapSort() {
        delegate?.mbBooksListView(self, needsSort: collectionView)
        if MBBookListViewViewModel.selectedSortingType == .desc {
            sortButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
        else {
            sortButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        sortButton.setTitle("By title", for: .normal)
        sortButton.tintColor = .gray
    }

    @objc private func didTapFilter() {
        delegate?.mbBooksListViewShouldShowFilters(updateOnCompletion: collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: topAnchor),
            sortButton.leftAnchor.constraint(equalTo: leftAnchor, constant: bounds.width / 6.5),
            sortButton.widthAnchor.constraint(equalToConstant: bounds.width / 4),
            sortButton.heightAnchor.constraint(equalToConstant: 70),

            filterButton.topAnchor.constraint(equalTo: topAnchor),
            filterButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -bounds.width / 6.5),
            filterButton.widthAnchor.constraint(equalToConstant: bounds.width / 4),
            filterButton.heightAnchor.constraint(equalToConstant: 70),

            collectionView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
