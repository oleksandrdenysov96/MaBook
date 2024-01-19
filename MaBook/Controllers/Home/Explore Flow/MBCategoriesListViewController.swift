//
//  MBCategoriesListViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import UIKit

class MBCategoriesListViewController: MBCartProvidingViewController {

    private let listView = MBCategoriesListView()

    private var data: [Categories] {
        return LocalStateManager.shared.categories
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(listView)
        listView.delegate = self
        listView.setupCollectionView()
        applyCartView(fromChild: listView)
        listView.floatingButton.showBadge(withBlink: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        needUpdateBadgeOn(listView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listView.leftAnchor.constraint(equalTo: view.leftAnchor),
            listView.rightAnchor.constraint(equalTo: view.rightAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}

extension MBCategoriesListViewController: MBCategoriesListViewDelegate {
    func mbCategoriesListView(_ listView: MBCategoriesListView,
                              needsSetup collection: UICollectionView) {
        collection.delegate = self
        collection.dataSource = self
    }

}

extension MBCategoriesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, 
                                            UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MBCategoriesCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? MBCategoriesCollectionViewCell else {
            MBLogger.shared.debugInfo("end: categories vc unable to setup cells")
            return UICollectionViewCell()
        }
        cell.configure(
            image: data[indexPath.row].image,
            titleText: data[indexPath.row].name
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        // MARK: define the data for page
        let vc = MBBooksListViewController(selectedCategory: data[indexPath.row].name)
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let itemReference = (screenBounds.width - 30) / 3.5
        return CGSize(width: itemReference, height: itemReference)
    }
}
