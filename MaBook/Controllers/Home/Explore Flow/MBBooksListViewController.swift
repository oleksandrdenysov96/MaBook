//
//  MBBooksListViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import UIKit
import UIScrollView_InfiniteScroll

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBBookListViewViewModel.Sections, Book
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBBookListViewViewModel.Sections, Book
>


class MBBooksListViewController: MBCartProvidingViewController {

    private let selectedCategory: String?
    private let selectedBooks: [Book]?

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
        case MBHomeSections.allBooks.rawValue:
            return .none
        case MBHomeSections.recentlyAdded.rawValue:
            return .timestamp
        case MBHomeSections.mostViewed.rawValue:
            return .views
        default:
            break
        }
        return .none
    }

    init() {
        self.selectedCategory = nil
        self.selectedBooks = nil
        super.init(nibName: nil, bundle: nil)
    }

    init(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        self.selectedBooks = nil
        super.init(nibName: nil, bundle: nil)
        title = "\(selectedCategory) books"
    }

    init(selectedBooks: [Book]) {
        self.selectedCategory = nil
        self.selectedBooks = selectedBooks
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(listView)
        view.addSubview(loader)
        listView.delegate = self
        applyCartView(fromChild: listView)
        listView.floatingButton.showBadge(withBlink: true)
        configureView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        needUpdateBadgeOn(listView)
    }

    private func configureView() {
        if let selectedCategory = selectedCategory {
            viewModel.fetchCategoriesBooks(
                for: selectedCategory
            ) { [weak self] success, _ in
                guard let self = self else {return}
                if success {
                    DispatchQueue.main.async {
                        self.listView.configureCollectionView()
                        self.applySnapshot(books: self.viewModel.books)
                        self.listView.updateCollectionView()
                    }
                }
            }
        }
        else if let selectedBooks = selectedBooks {
            self.listView.hideSortAndFilterButtons()
            self.listView.configureCollectionView()
            self.applySnapshot(books: selectedBooks)
            self.listView.updateCollectionView()
        }
        else {
            self.listView.configureCollectionView()
            self.applySnapshot(books: viewModel.books)
            self.listView.updateCollectionView()
        }
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
    func mbBooksListViewShouldShowFilters(updateOnCompletion collection: UICollectionView) {

        guard let currentPage = viewModel.allBooksData.info.currentPage else {
            MBLogger.shared.debugInfo(
                "end: list vc unable to create filter vc without current page url"
            )
            return
        }
        let filtersVC = MBBookFilterViewController(inititalData: currentPage) { filterUrl in
            DispatchQueue.main.async { [weak self] in
                self?.loader.startLoader()

                UIView.animate(withDuration: 0.3) {
                    collection.alpha = 0.5
                } completion: { _ in
                    self?.viewModel.fetchBooks(via: filterUrl) { [weak self] success, newData  in
                        guard let self = self, let newData = newData else {return}
                        DispatchQueue.main.async {

                            self.viewModel.books = newData
                            self.dataSourceSnapshot.deleteAllItems()
                            self.applySnapshot(books: newData)

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
        filtersVC.modalTransitionStyle = .coverVertical
        filtersVC.title = "Choose Filter"
        navigationController?.present(UINavigationController(rootViewController: filtersVC), animated: true)
    }
    
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
                    bookImage: book.images.first, genre: book.genre
                )
                cell.tag = indexPath.row
                cell.delegate = self
                return cell
            }
        )
    }

    private func applySnapshot(books: [Book]) {
        dataSourceSnapshot.appendSections([MBBookListViewViewModel.Sections.list])
        dataSourceSnapshot.appendItems(books)
        guard let dataSource = dataSource else { return }
        dataSource.apply(dataSourceSnapshot, animatingDifferences: true)
    }

    func mbBooksListView(_ listView: MBBooksListView, needsUpdate collection: UICollectionView) {
        collection.infiniteScrollDirection = .vertical

        collection.addInfiniteScroll { [weak self] collectionView in
            self?.viewModel.fetchBooks { [weak self] success, newData in
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let itemReference = (screenBounds.width - 30) / 2.1
        return CGSize(width: itemReference, height: itemReference * 1.9)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailsVC = MBBookDetailsViewController(with: viewModel.books[indexPath.row])
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension MBBooksListViewController: MBBookListCollectionViewCellDelegate {
    func mbBookListCollectionViewCellDidTapAddToCart(on cell: MBBookListCollectionViewCell) {
        let selectedItem = viewModel.books[cell.tag]
        viewModel.addToCart(item: selectedItem) { [weak self] success in
            DispatchQueue.main.async {
                if success, let count = LocalStateManager.shared.cartItemsCount {
                    self?.listView.floatingButton.updateBadgeCounter(withCount: count)
                }
            }
        }
    }
    

}
