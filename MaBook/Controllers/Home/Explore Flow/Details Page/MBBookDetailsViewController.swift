//
//  MBBookDetailsViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 30.12.2023.
//

import UIKit
import Combine

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBBooksDetailViewViewModel.SectionCellType, MBBooksDetailViewViewModel.Items
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBBooksDetailViewViewModel.SectionCellType, MBBooksDetailViewViewModel.Items
>


class MBBookDetailsViewController: UIViewController {

    private var dataSource: DataSource!
    private var dataSourceSnapshot = DataSourceSnapshot()
    private var bookData: Book

    private let detailsView = MBBookDetailsView()
    private let viewModel: MBBooksDetailViewViewModel

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
        detailsView.configureCartButtonPrice()
        setupLikeButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupLikeButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: /*self.viewModel.isFavorite ? UIImage(systemName: "heart.fill") :*/ UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapHeart)
        )
        navigationItem.rightBarButtonItem?.tintColor = /*self.viewModel.isFavorite ? .red :*/ .black

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
//                navigationItem.rightBarButtonItem?.tintColor = .black
//                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
                self.viewModel.updateFavoritesForBook(action: .delete, id: String(self.bookData.id))
            }
            else {
//                navigationItem.rightBarButtonItem?.tintColor = .red
//                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                self.viewModel.updateFavoritesForBook(action: .post, body: self.bookData)
            }
        }
        viewModel.isFavorite.value.toggle()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            detailsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}


extension MBBookDetailsViewController: MBBookDetailsViewDelegate {
    func mbBookDetailsView(_ detailsView: MBBookDetailsView, needsConfigure collection: UICollectionView) {

        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            return self?.viewModel.createLayout(for: section)
        }
        collection.collectionViewLayout = layout

        dataSource = DataSource(collectionView: collection, cellProvider: { 
            (collectionView, indexPath, item) -> UICollectionViewCell? in

            switch item {
            case .photoCell(let model):
                let cell: MBBookPhotosCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(with: model.imageURL)
                return cell
            case .summaryCell(let model):
                let cell: MBBookSummaryCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(with: model)
                return cell
            case .conditionCell(let model):
                let cell: MBBookInfoCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(with: model)
                return cell
            case .pagesCell(let model):
                let cell: MBBookInfoCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(with: model)
                return cell
            case .dimensionsCell(let model):
                let cell: MBBookInfoCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)
                cell.configure(with: model)
                return cell
            }
        })
    }

    private func applySnapshot() {
        dataSourceSnapshot.appendSections(viewModel.sections)

        for sectionIndex in 0..<viewModel.sections.count {
            switch viewModel.sections[sectionIndex] {
            case .photo:
                dataSourceSnapshot.appendItems(
                    viewModel.photoItems,
                    toSection: viewModel.sections[sectionIndex]
                )
            default:
                dataSourceSnapshot.appendItems(
                    [viewModel.items[sectionIndex - 1]],
                    toSection: viewModel.sections[sectionIndex]
                )
            }
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

//                UIView.animate(withDuration: 0.2) {
//                    if self.viewModel.isFavorite {
//                        self.navigationItem.rightBarButtonItem?.tintColor = .red
//                        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
////                        self.viewModel.updateFavoritesForBook(action: .post, body: self.bookData)
//
//                    }
//                    else {
//                        self.navigationItem.rightBarButtonItem?.tintColor = .black
//                        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
////                        self.viewModel.updateFavoritesForBook(action: .delete, id: String(self.bookData.id))
//                    }
//
//                }
            }
        }
    }
}
