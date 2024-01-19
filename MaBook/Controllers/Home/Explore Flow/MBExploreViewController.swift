//
//  MBExploreViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 25.12.2023.
//

import UIKit

class MBExploreViewController: MBCartProvidingViewController, UISearchControllerDelegate {

    private let viewModel = MBExploreViewViewModel()
    private let exploreView = MBExploreView()
    private let searchController = MBSearchViewController()
    private let refreshControl = UIRefreshControl()
    private let loader = MBLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "notification"),
            style: .done,
            target: self,
            action: #selector(didTapNotifications)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.delegate = self
        searchController.searchBar.placeholder = "Book name or author name"
        view.addSubviews(views: exploreView, loader)
        applyCartView(fromChild: exploreView)

        loader.startLoader()
        exploreView.delegate = self
        updateHomePage()
        addTargets()
    }


    @objc private func didTapNotifications() {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func updateHomePage(_ completion: @escaping () -> Void = {}) {
        viewModel.performMainRequests() { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.exploreView.configureCollectionView()
//                    self?.exploreView.floatingButton.initiateBadge()
                }
            }
            else {
                self?.loader.stopLoader()
                self?.presentSingleOptionErrorAlert(
                    title: "Damn...",
                    message: MBStrings
                        .mbExploreViewControllerFailedWithRefreshAlert,
                    buttonTitle: "Got it")
            }
            completion()
        }
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.01) { [weak self] in
            self?.exploreView.alpha = 0
        } completion: { [weak self] _ in
            self?.exploreView.isHidden = true
        }
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.exploreView.isHidden = false
            self?.exploreView.alpha = 1
        }
    }

    private func addTargets() {
        refreshControl.addTarget(self, action: #selector(refreshHome(_:)), for: .valueChanged)
    }

    @objc private func refreshHome(_ sender: UIRefreshControl) {
        updateHomePage() {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            exploreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exploreView.leftAnchor.constraint(equalTo: view.leftAnchor),
            exploreView.rightAnchor.constraint(equalTo: view.rightAnchor),
            exploreView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}




// MARK: VIEW DELEGATE

extension MBExploreViewController: MBExploreViewDelegate {

    func mbExploreViewNeedConfigureCollectionView(
        _ exploreView: MBExploreView,
        collectionView: UICollectionView,
        _ completion: @escaping () -> Void)
    {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            return self?.viewModel.createSectionLayout(for: section)
        }
        DispatchQueue.main.async { [weak self] in
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout = layout
            collectionView.refreshControl = self?.refreshControl
            collectionView.reloadData()

            self?.loader.stopLoader()

            UIView.animate(withDuration: 0.2) {
                collectionView.isHidden = false
                collectionView.alpha = 1
            }
            completion()
        }
    }
}


// MARK: COLLECTION VIEW DELEGATE

extension MBExploreViewController: UICollectionViewDelegate, 
                                    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dataToPass: Book?
        switch viewModel.sections[indexPath.section] {
        case .categories:
            let categoryListVC = MBBooksListViewController(
                selectedCategory: viewModel.categories[indexPath.row].name
            )
            navigationController?.pushViewController(categoryListVC, animated: true)
            return
        case .allBooks:
            dataToPass = viewModel.allBooks?.books[indexPath.row]
        case .recentlyAdded:
            dataToPass = viewModel.recentlyAdded?.books[indexPath.row]
        case .mostViewed:
            dataToPass = viewModel.mostViewed?.books[indexPath.row]
        }

        guard let dataToPass = dataToPass else {
            MBLogger.shared.debugInfo("end: vc has ended with data failure for details vc")
            return
        }
        let sectionListVC = MBBookDetailsViewController(with: dataToPass)
        navigationController?.pushViewController(sectionListVC, animated: true)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let allBooks = viewModel.allBooks?.books,
              let recentlyAdded = viewModel.recentlyAdded?.books,
              let mostViewed = viewModel.mostViewed?.books
        else { return 0 }

        switch viewModel.sections[section] {
        case .categories:
            return viewModel.categories.count
        case .allBooks:
            return allBooks.count
        case .recentlyAdded:
            return recentlyAdded.count
        case .mostViewed:
            return mostViewed.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch viewModel.sections[indexPath.section] {
        case .categories:
            let cell: MBCategoriesCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(
                image: viewModel.categories[indexPath.row].image,
                titleText: viewModel.categories[indexPath.row].name
            )
            return cell

        case .allBooks:
            guard let book = viewModel.allBooks?.books[indexPath.row] else {fatalError()}
            let cell: MBBookCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(
                badgeType: .none, badgeText: nil,
                price: book.price, bookTitle: book.title,
                bookImage: book.images[0], genre: book.genre
            )
            return cell

        case .recentlyAdded:
            guard let recentlyAddedBook = viewModel.recentlyAdded?.books[indexPath.row] else {fatalError()}
            let cell: MBBookCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(
                badgeType: .timestamp, badgeText: recentlyAddedBook.createdAt,
                price: recentlyAddedBook.price, bookTitle: recentlyAddedBook.title,
                bookImage: recentlyAddedBook.images.first, genre: recentlyAddedBook.genre
            )
            return cell

        case .mostViewed:
            guard let mostViewedBook = viewModel.mostViewed?.books[indexPath.row] else {fatalError()}
            let cell: MBBookCollectionViewCell = collectionView
                .dequeueReusableCell(for: indexPath)
            cell.configure(
                badgeType: .views, badgeText: String(mostViewedBook.view),
                price: mostViewedBook.price, bookTitle: mostViewedBook.title,
                bookImage: mostViewedBook.images[0], genre: mostViewedBook.genre
            )
            return cell
        }
    }


    // MARK: HEADER SEE ALL TARGETS

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MBExploreSectionCollectionReusableView.identifier,
                for: indexPath
            ) as? MBExploreSectionCollectionReusableView
            else {
                return UICollectionReusableView()
            }
            
            let currentSection = viewModel.sections[indexPath.section]
            header.delegate = self
            header.configureHeader(with: currentSection.rawValue)
            header.tag = indexPath.section
            return header
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }

}

extension MBExploreViewController: MBExploreSectionCollectionReusableViewDelegate {

    func mbExploreSectionCollectionReusableViewDidTapSeeAll(
        _ reusableView: MBExploreSectionCollectionReusableView
    ) {
        let section = viewModel.sections[reusableView.tag]
        let listVC = section == .categories ?
        MBCategoriesListViewController() : MBBooksListViewController()

        viewModel.setSelectedSectionData(for: section)
        listVC.title = section.rawValue
        navigationController?.pushViewController(
            listVC, animated: true
        )
    }
}
