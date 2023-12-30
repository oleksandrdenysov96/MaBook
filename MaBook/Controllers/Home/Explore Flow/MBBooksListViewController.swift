//
//  MBBooksListViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import UIKit
import UIScrollView_InfiniteScroll

class MBBooksListViewController: UIViewController {

    private let listView = MBBooksListView()
    private let viewModel = MBBookListViewViewModel()
    private let loader: MBLoader = {
        let loader = MBLoader()
        loader.backgroundColor = .clear
        return loader
    }()


    private var cellBadge: CellBadgeType {
        guard let currentController = title else {
            MBLogger.shared.debugInfo("end: not determined vc - no title")
            fatalError()
        }
        switch currentController {
        case Sections.allBooks.rawValue:
            return .none
        case Sections.recentlyAdded.rawValue:
            return .timestamp
        case Sections.mostViewed.rawValue:
            return .views
        default:
            break
        }
        return .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(listView)
        view.addSubview(loader)
        listView.delegate = self
        listView.configureCollectionView()
        listView.updateCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            listView.leftAnchor.constraint(equalTo: view.leftAnchor),
            listView.rightAnchor.constraint(equalTo: view.rightAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }
}

extension MBBooksListViewController: MBBooksListViewDelegate {
    func mbBooksListView(_ listView: MBBooksListView, needsSort collection: UICollectionView) {

        DispatchQueue.main.async { [weak self] in
            self?.loader.startLoader()

            UIView.animate(withDuration: 0.3) {
                collection.alpha = 0
            } completion: { _ in
                collection.isHidden = true

                self?.viewModel.performSorting { [weak self] success in
                    DispatchQueue.main.async {
                        if success {
                            collection.reloadData()

                            let indexPath: IndexPath? = IndexPath(item: 0, section: 0)
                            if let firstIndexPath = indexPath {
                                collection.scrollToItem(at: firstIndexPath, at: .top, animated: false)
                            }
                        }
                        else {
                            self?.presentSingleOptionErrorAlert(
                                message: "We're in trouble to sort this page"
                            )
                        }
                        UIView.animate(withDuration: 0.1) {
                            collection.isHidden = false
                            collection.alpha = 1
                        } completion: { _ in
                            self?.loader.stopLoader()
                        }
                    }
                }
            }
        }
    }
    

    func mbBooksListView(_ listView: MBBooksListView, needsConfigure collection: UICollectionView) {
        collection.delegate = self
        collection.dataSource = self
    }

    func mbBooksListView(_ listView: MBBooksListView, needsUpdate collection: UICollectionView) {
        collection.infiniteScrollDirection = .vertical

        collection.addInfiniteScroll { [weak self] collectionView in
            self?.viewModel.fetchMoreBooks { [weak self] success, newData in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, success == true, let newData = newData else {
                        collectionView.finishInfiniteScroll()
                        return
                    }

                    let startIndex = self.viewModel.books.count
                    self.viewModel.books.append(contentsOf: newData)

                    let endIndex = self.viewModel.books.count
                    let indexPaths = (startIndex..<endIndex).compactMap { index in
                        return IndexPath(row: index, section: 0)
                    }

                    collection.performBatchUpdates {
                        collection.insertItems(at: indexPaths)
                    } completion: { _ in
                        collectionView.finishInfiniteScroll()
                    }
                }
            }
        }
    }


}

extension MBBooksListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < viewModel.books.count, let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MBBookListCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? MBBookListCollectionViewCell else {
            MBLogger.shared.debugInfo("end: vc has ended with failure of creating cell")
            fatalError()
        }
        let currentBook = viewModel.books[indexPath.row]
        var badgeText: String?

        switch cellBadge {
        case .none: badgeText = nil
        case .timestamp: badgeText = currentBook.createdAt
        case .views: badgeText = String(currentBook.view)
        }

        cell.configure(
            badgeType: cellBadge,
            badgeText: badgeText,
            price: String(currentBook.price),
            bookTitle: currentBook.title,
            bookImage: currentBook.images[0],
            genre: currentBook.genre
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let itemReference = (screenBounds.width - 30) / 2.1
        return CGSize(width: itemReference, height: itemReference * 1.9)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
