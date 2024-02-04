//
//  MBCartViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 08.01.2024.
//

import UIKit
import Combine

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBBookListViewViewModel.Sections, Book
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBBookListViewViewModel.Sections, Book
>

class MBCartViewController: UIViewController {

    public let removeFromCartEvent = PassthroughSubject<Int, Never>()

    private let cartView = MBCartView()
    private let viewModel = MBCartViewModel()

    private var dataSource: DataSource!
    private var dataSourceSnapshot = DataSourceSnapshot()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Cart"
        view.backgroundColor = .white
        view.addSubview(cartView)
        cartView.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector((didTapClose))
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchBasket { [weak self] success in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.cartView.setupCollection()
                self.cartView.configureSummarySection(
                    itemPrice: self.viewModel.totalPrice,
                    shipmentFee: "Collect on delivery",
                    totalPrice: self.viewModel.totalPrice
                )
                self.applySnapshot()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSourceSnapshot.deleteAllItems()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartView.leftAnchor.constraint(equalTo: view.leftAnchor),
            cartView.rightAnchor.constraint(equalTo: view.rightAnchor),
            cartView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }


    @objc private func didTapClose() {
        presentingViewController?.dismiss(animated: true)
    }
}

extension MBCartViewController: MBCartViewDelegate {

    func mbCartView(needsSetup collection: UICollectionView) {
        collection.delegate = self
        dataSource = DataSource(
            collectionView: collection, cellProvider: {
                (collectionView, indexPath, book) -> MBCartItemCollectionViewCell in

                let cell: MBCartItemCollectionViewCell = collection
                    .dequeueReusableCell(for: indexPath)

                cell.configure(
                    imageURL: book.images.first,
                    title: book.title,
                    price: book.price,
                    author: book.author
                )
                cell.tag = indexPath.row
                cell.delegate = self
                return cell
            }
        )
    }

    private func applySnapshot() {
        dataSourceSnapshot.appendSections([MBBookListViewViewModel.Sections.list])
        dataSourceSnapshot.appendItems(viewModel.basketItems)
        dataSource.apply(dataSourceSnapshot, animatingDifferences: true)
    }
}


extension MBCartViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let itemReference = screenBounds.width - 60
        return CGSize(width: itemReference, height: itemReference / 2)
    }
}

extension MBCartViewController: MBCartItemCollectionViewCellDelegate {
    func mbCartItemCollectionViewCellDidTapTrash(on cell: MBCartItemCollectionViewCell) {
        guard let indexPath = cartView.collectionView.indexPath(for: cell),
                let selectedOnItem = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        viewModel.removeFromBasket(byId: String(selectedOnItem.id)) { [weak self] success in
            guard let self = self else {return}
            if success {
                if let indexPath = self.dataSource.indexPath(for: selectedOnItem) {
                    DispatchQueue.main.async {
                        self.dataSourceSnapshot.deleteItems([selectedOnItem])
                        self.dataSource.apply(
                            self.dataSourceSnapshot,
                            animatingDifferences: true
                        )
                        self.cartView.updateTotalSumWith(
                            newPrice: self.viewModel.totalPrice
                        )
                        LocalStateManager.shared.cartItemsCount.send(String(
                            self.viewModel.basketItems.count
                        ))
                        self.removeFromCartEvent.send(selectedOnItem.id)
                    }
                }
            }
        }
    }
    


}
