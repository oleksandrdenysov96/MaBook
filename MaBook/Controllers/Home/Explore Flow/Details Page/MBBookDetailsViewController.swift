//
//  MBBookDetailsViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 30.12.2023.
//

import UIKit
import Combine

class MBBookDetailsViewController: UIViewController {

    private var bookData: Books
    private var cancellables = Set<AnyCancellable>()

    private let detailsView = MBBookDetailsView()
    private let viewModel: MBBooksDetailViewViewModel


    init(with data: Books) {
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
        detailsView.configureCartButtonPrice()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
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
        collection.delegate = self
        collection.dataSource = self

        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            return self?.viewModel.createLayout(for: section)
        }
        collection.collectionViewLayout = layout
    }
    
    func mbBookDetailsView(_ detailsView: MBBookDetailsView, needsConfigure button: MBButton) {
        viewModel.fetchPrice { [weak self] newData in
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


extension MBBookDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch viewModel.sections[section] {
        case .photo(let model): return model.imageURL.count
        case .summary(_): return 1
        case .condition(_): return 1
        case .pages(_): return 1
        case .dimensions(_): return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections[indexPath.section] {
        case .photo(let model):
            let cell: MBBookPhotosCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(with: model.imageURL[indexPath.row])
            return cell
        case .summary(let model):
            let cell: MBBookSummaryCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(with: model)
            return cell
        case .condition(let model):
            let cell: MBBookInfoCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(with: model)
            return cell
        case .pages(let model):
            let cell: MBBookInfoCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(with: model)
            return cell
        case .dimensions(let model):
            let cell: MBBookInfoCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(with: model)
            return cell
        }
    }
}
