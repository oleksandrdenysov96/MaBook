//
//  MBBookDetailsViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 30.12.2023.
//

import UIKit
import Combine

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBBooksDetailViewViewModel.SectionCellType, UUID
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBBooksDetailViewViewModel.SectionCellType, UUID
>


class MBBookDetailsViewController: UIViewController {

    private var dataSource: DataSource!
    private var dataSourceSnapshot = DataSourceSnapshot()
    private var bookData: Book

    private let detailsView = MBBookDetailsView()
    private let viewModel: MBBooksDetailViewViewModel

    public private(set) var isAddedToCartSubject = PassthroughSubject<Bool, Never>()

    private var cancellable = Set<AnyCancellable>()


    init(with data: Book) {
        self.bookData = data
        self.viewModel = .init(with: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Book Details"
        view.backgroundColor = .white
        view.addSubview(detailsView)
        detailsView.delegate = self
        detailsView.configureCollectionView()
        applySnapshot()
//        detailsView.configureCartButtonPrice()
        setupLikeButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupDedicatedView(detailsView)
    }

    private func setupLikeButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapHeart)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black

        self.viewModel.isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
            UIView.animate(withDuration: 0.2) {
                self?.navigationItem.rightBarButtonItem?.image = isLiked
                ? UIImage(systemName: "heart.fill")
                : UIImage(systemName: "heart")

                self?.navigationItem.rightBarButtonItem?.tintColor = isLiked
                ? .red : .black
            }
        }
        .store(in: &cancellable)
    }

    
    @objc private func didTapHeart() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {return}
            if self.viewModel.isFavorite.value {
                self.viewModel.updateFavoritesForBook(
                    action: .delete, id: String(self.bookData.id)
                )
            }
            else {
                self.viewModel.updateFavoritesForBook(
                    action: .post, body: self.bookData
                )
            }
        }
        viewModel.isFavorite.value.toggle()
        LocalStateManager.shared
            .shouldFetchFavorites = true
    }
}


extension MBBookDetailsViewController: MBBookDetailsViewDelegate {
    func mbBookDetailsView(_ detailsView: MBBookDetailsView, needsConfigure collection: UICollectionView) {

        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            return self?.viewModel.createLayout(for: section)
        }
        collection.collectionViewLayout = layout

        dataSource = DataSource(collectionView: collection, cellProvider: { 
            [unowned self] (_, indexPath, _) -> UICollectionViewCell? in

            let section = MBBooksDetailViewViewModel
                .SectionCellType.allCases[indexPath.section]

            switch section {
            case .photo:
                let cell: MBBookPhotosCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(
                    with: self.bookData.images[indexPath.row]
                )
                return cell
            case .summary:
                let cell: MBBookSummaryCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(with: self.bookData)
                return cell
            case .condition:
                let cell: MBBookInfoCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(
                    title: section.rawValue.capitalized,
                    value: self.bookData.condition
                )
                return cell
            case .pages:
                let cell: MBBookInfoCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(
                    title: section.rawValue.capitalized,
                    value: String(self.bookData.pages)
                )
                return cell
            case .dimensions:
                let cell: MBBookInfoCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(
                    title: section.rawValue.capitalized,
                    value: self.bookData.dimensions
                )
                return cell
            case .addToCart:
                let cell: MBCartButtonCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                self.viewModel.fetchSecondaryData { newData in
                    cell.configure(
                        pointValue: self.bookData.price,
                        currencyValue: newData.price,
                        inCart: self.bookData.isAddedToCart
                    )
                }
                cell.tapCartButtonSubject.sink {
                    self.viewModel.addToCart(item: self.bookData) { isAdded in
                        if isAdded {
                            self.isAddedToCartSubject.send(isAdded)
                            cell.updateButtonState(to: isAdded)
                        }
                    }
                }
                .store(in: &cancellable)
                return cell

            }
        })
    }

    private func applySnapshot() {
        var sections = viewModel.sections
        dataSourceSnapshot.appendSections([sections.removeFirst()])
        dataSourceSnapshot.appendItems(viewModel.photosIdentifiers)

        let itemsIdentifiers = [
            viewModel.summaryCellIdentifier,
            viewModel.conditionCellIdentifier,
            viewModel.pagesCellIdentifier,
            viewModel.dimensionsCellIdentifier,
            viewModel.addToCartCellIdentifier
        ]
        for (section, item) in zip(sections, itemsIdentifiers) {
            dataSourceSnapshot.appendSections([section])
            dataSourceSnapshot.appendItems([item])
        }
        dataSource.apply(dataSourceSnapshot, animatingDifferences: true)
    }

    func mbBookDetailsView(_ detailsView: MBBookDetailsView, needsConfigure button: MBButton) {
        viewModel.fetchSecondaryData { [weak self] newData in
            guard let self = self else {return}
            DispatchQueue.main.async {
                button.setTitle(
                    "Add to Cart (\(self.bookData.price)P | \(String(newData.price)))",
                    for: .normal
                )
                button.isLoading = false
            }
        }
    }
}
