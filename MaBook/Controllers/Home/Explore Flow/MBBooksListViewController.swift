//
//  MBBooksListViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import UIKit
import Combine
import UIScrollView_InfiniteScroll

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBBookListViewViewModel.Sections, UUID
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBBookListViewViewModel.Sections, UUID
>


class MBBooksListViewController: MBCartProvidingViewController {
    
    private let selectedSeeAllSection: MBEndpoint?
    private let selectedCategory: String?
    private let selectedBooks: [Book]?

    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()

    private let listView = MBBooksListView()
    private let viewModel = MBBookListViewViewModel()

    private var shouldUpdateCartButtonSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

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
        case MBExploreViewViewModel.Sections.allBooks.rawValue:
            return .none
        case MBExploreViewViewModel.Sections.recentlyAdded.rawValue:
            return .timestamp
        case MBExploreViewViewModel.Sections.mostViewed.rawValue:
            return .views
        default:
            break
        }
        return .none
    }

    init(selectedSeeAllSection: MBEndpoint) {
        self.selectedSeeAllSection = selectedSeeAllSection
        self.selectedCategory = nil
        self.selectedBooks = nil
        super.init(nibName: nil, bundle: nil)
    }

    init(selectedCategory: String) {
        self.selectedSeeAllSection = nil
        self.selectedCategory = selectedCategory
        self.selectedBooks = nil
        super.init(nibName: nil, bundle: nil)
        title = "\(selectedCategory) books"
    }

    init(selectedBooks: [Book]) {
        self.selectedSeeAllSection = nil
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
//        applyCartView(fromChild: listView)
        configureView()
        self.applyCartButtonTarget(
            listView.floatingButton
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupDedicatedView(listView, topMargin: 10)
        setupLoader(loader)
    }

    private func configureView() {
        if let selectedCategory = selectedCategory {
            self.loader.startLoader()
            viewModel.fetchCategoriesBooks(
                for: selectedCategory
            ) { [unowned self] success, _ in
                if success {
                    DispatchQueue.main.async {
                        self.listView.configureCollectionView()
                        self.applySnapshot()
                        self.listView.updateCollectionView()
                        self.loader.stopLoader()
                    }
                }
            }
        }
        else if let selectedBooks = selectedBooks {
            self.viewModel.books = selectedBooks
            self.listView.hideSortAndFilterButtons()
            self.listView.configureCollectionView()
            self.applySnapshot()
//            self.listView.updateCollectionView()
        }
        else {
            guard let selectedSeeAllSection else {return}
            self.loader.startLoader()
            self.viewModel.fetchInitialBooks(in: selectedSeeAllSection) { [unowned self] success in
                DispatchQueue.main.async {
                    if success {
                        self.listView.configureCollectionView()
                        self.applySnapshot()
                        self.listView.updateCollectionView()
                        self.loader.stopLoader()
                    }
                }
            }
        }
    }
}

extension MBBooksListViewController: MBBooksListViewDelegate {
    func mbBooksListViewShouldShowFilters(updateOnCompletion collection: UICollectionView) {

        guard let currentPage = viewModel.allBooksData!.info.currentPage else {
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
                    self?.viewModel.fetchInitialBooks(via: filterUrl) { [weak self] in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            self.applySnapshot(resetOldItems: true)

                            UIView.animate(withDuration: 0.1) {
                                collection.alpha = 1
                            } completion: { _ in
                                self.loader.stopLoader()
                                //
                                //                                let indexPath = IndexPath(item: 0, section: 0)
                                //                                collection.scrollToItem(at: indexPath, at: .top, animated: true)
                            }

                        }
                    }
                }
            }
        }
        filtersVC.modalTransitionStyle = .coverVertical
        filtersVC.title = "Choose Filter"
        navigationController?.present(
            UINavigationController(rootViewController: filtersVC), 
            animated: true
        )
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
                            self.applySnapshot(resetOldItems: true)
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
                [weak self] (collectionView, indexPath, identifier) -> MBBookListCollectionViewCell in

                guard let self = self else { fatalError() }
//                guard let model = self.viewModel.bookCellsModels.first(where: {
//                    $0.identifier == identifier
//                }) else {
//                    fatalError()
//                }
                let model = self.viewModel.bookCellsModels[indexPath.row]
                let cell: MBBookListCollectionViewCell = collectionView
                    .dequeueReusableCell(for: indexPath)
                cell.configure(with: model.book, withBadge: cellBadge)
                cell.tag = indexPath.row
                cell.delegate = self

                return cell
            }
        )
    }

    private func applySnapshot(resetOldItems: Bool = false) {
        if resetOldItems {
            dataSourceSnapshot.deleteAllItems()
        }
        dataSourceSnapshot.appendSections([MBBookListViewViewModel.Sections.list])
        let identifiers = viewModel.bookCellsModels.compactMap {
            return $0.identifier
        }
        dataSourceSnapshot.appendItems(identifiers)
        guard let dataSource = dataSource else { return }
        dataSource.apply(dataSourceSnapshot, animatingDifferences: true)
    }


    private func appendItems(_ modelIdentifiers: [UUID], to: DataSourceSnapshot) {
        dataSourceSnapshot.appendItems(modelIdentifiers)
        guard let dataSource = dataSource else { return }
        dataSource.apply(dataSourceSnapshot, animatingDifferences: true)
    }

    private func updateDataSourceItemAt(index: Int) {
        viewModel.updateModelsIfAddedToCartAt(index: index)
        let itemIdentifier = dataSourceSnapshot.itemIdentifiers[index]
        dataSourceSnapshot.reloadItems([itemIdentifier])
        dataSource?.apply(dataSourceSnapshot, animatingDifferences: true)
    }


    func mbBooksListView(_ listView: MBBooksListView, needsUpdate collection: UICollectionView) {
        collection.infiniteScrollDirection = .vertical

        collection.addInfiniteScroll { [weak self] collectionView in
            self?.viewModel.fetchNextPageBooks { [weak self] success, newData in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, success == true,
                          let newData = newData
                    else {
                        collectionView.finishInfiniteScroll()
                        return
                    }
                    self.appendItems(newData, to: self.dataSourceSnapshot)
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

        detailsVC.isAddedToCartSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAdded in
            guard let self else {return}
            if isAdded {
                self.updateDataSourceItemAt(index: indexPath.row)
            }
        }
        .store(in: &cancellables)

        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension MBBooksListViewController: MBBookListCollectionViewCellDelegate {
    func mbBookListCollectionViewCellDidTapAddToCart(on cell: MBBookListCollectionViewCell) {
        let selectedItem = viewModel.books[cell.tag]
        viewModel.addToCart(item: selectedItem) { success in
            if success {
                DispatchQueue.main.async {
                    self.updateDataSourceItemAt(index: cell.tag)
                }
            }
        }
    }
}
