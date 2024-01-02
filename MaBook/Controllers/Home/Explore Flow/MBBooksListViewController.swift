//
//  MBBooksListViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import UIKit
import UIScrollView_InfiniteScroll

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBBookListViewViewModel.Sections, Books
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBBookListViewViewModel.Sections, Books
>


class MBBooksListViewController: UIViewController {

    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()

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
        applySnapshot(books: viewModel.books)
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
                collection.alpha = 0.5
            } completion: { _ in
                self?.viewModel.performSorting { [weak self] success in
                    guard let self = self else {return}
                    DispatchQueue.main.async {
                        if success {
                            self.dataSourceSnapshot.deleteAllItems()
                            self.applySnapshot(books: self.viewModel.books)
                        }
                        else {
                            self.presentSingleOptionErrorAlert(
                                message: "We're in trouble to sort this page"
                            )
                        }
                        UIView.animate(withDuration: 0.1) {
                            collection.alpha = 1
                        } completion: { _ in
                            self.loader.stopLoader()

                            let indexPath = IndexPath(item: 0, section: 0)
                            collection.scrollToItem(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    

    func mbBooksListView(_ listView: MBBooksListView, needsConfigure collection: UICollectionView) {
        collection.delegate = self
        dataSource = DataSource(
            collectionView: collection, cellProvider: {
                [weak self] (collectionView, indexPath, book) -> MBBookListCollectionViewCell in

                guard let self = self else { fatalError() }
                let cell: MBBookListCollectionViewCell = collectionView
                    .dequeueReusableCell(for: indexPath)
                var badgeText: String?

                switch self.cellBadge {
                case .none: 
                    badgeText = nil
                case .timestamp: 
                    badgeText = book.createdAt
                case .views: 
                    badgeText = String(book.view)
                }

                cell.configure(
                    badgeType: cellBadge, badgeText: badgeText,
                    price: String(book.price), bookTitle: book.title,
                    bookImage: book.images[0], genre: book.genre
                )
                return cell
            }
        )
    }

    private func applySnapshot(books: [Books]) {
        dataSourceSnapshot.appendSections([MBBookListViewViewModel.Sections.list])
        dataSourceSnapshot.appendItems(books)
        guard let dataSource = dataSource else { return }
        dataSource.apply(dataSourceSnapshot, animatingDifferences: true)
    }

    func mbBooksListView(_ listView: MBBooksListView, needsUpdate collection: UICollectionView) {
        collection.infiniteScrollDirection = .vertical

        collection.addInfiniteScroll { [weak self] collectionView in
            self?.viewModel.fetchMoreBooks { [weak self] success, newData in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, success == true,
                          let newData = newData, let dataSource = self.dataSource else {
                        collectionView.finishInfiniteScroll()
                        return
                    }

                    self.viewModel.books.append(contentsOf: newData)
                    self.dataSourceSnapshot.appendItems(newData)
                    dataSource.apply(dataSourceSnapshot, animatingDifferences: true)

                    collectionView.finishInfiniteScroll()
                }
            }
        }
    }
}

extension MBBooksListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.books.count
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
