//
//  MBExploreViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 25.12.2023.
//

import UIKit

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBExploreViewViewModel.Sections, MBExploreViewViewModel.Items
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBExploreViewViewModel.Sections, MBExploreViewViewModel.Items
>

class MBExploreViewController: MBCartProvidingViewController, UISearchControllerDelegate {

    private let viewModel = MBExploreViewViewModel()
    private let exploreView = MBExploreView()
    private let searchController = MBSearchViewController()
    private let refreshControl = UIRefreshControl()
    private let loader = MBLoader()

    private var dataSource: DataSource?
    private var snapshot = DataSourceSnapshot()

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
//        applyCartView(fromChild: exploreView)

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
//        setupConstraints()
        setupDedicatedView(exploreView)
        setupLoader(loader)
    }

    private func updateHomePage(_ completion: @escaping () -> Void = {}) {
        viewModel.performMainRequests() { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.exploreView.configureCollectionView()
                    self?.applySnapshot()
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
        self.applyCartButtonTarget(exploreView.floatingButton)
    }

    @objc private func refreshHome(_ sender: UIRefreshControl) {
        exploreView.updateCollectionView() { [unowned self] success in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()

                if !success {
                    self.presentSingleOptionErrorAlert(
                        message: "We have an issues with feed update"
                    )
                }
            }
        }
    }
}


// MARK: VIEW DELEGATE

extension MBExploreViewController: MBExploreViewDelegate {

    func mbExploreViewNeedConfigure(
        collectionView: UICollectionView,
        _ completion: @escaping () -> Void)
    {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            return self?.viewModel.createSectionLayout(for: section)
        }

        collectionView.collectionViewLayout = layout
        collectionView.refreshControl = self.refreshControl
        collectionView.delegate = self

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView, cellProvider: {
                (collectionView, indexPath, item) -> UICollectionViewCell? in
                
                switch item {
                case .categoryItems(let model):
                    let cell: MBCategoriesCollectionViewCell = collectionView
                        .dequeueReusableCell(for: indexPath)
                    cell.configure(image: model.image, titleText: model.name)
                    return cell

                case .allBooksItems(let model):
                    let cell: MBBookCollectionViewCell = collectionView
                        .dequeueReusableCell(for: indexPath)
                    cell.configure(with: model, withBadge: .none)
                    return cell

                case .recentlyAddedItems(let model):
                    let cell: MBBookCollectionViewCell = collectionView
                        .dequeueReusableCell(for: indexPath)
                    cell.configure(with: model, withBadge: .timestamp)
                    return cell

                case .mostViewedItems(let model):
                    let cell: MBBookCollectionViewCell = collectionView
                        .dequeueReusableCell(for: indexPath)
                    cell.configure(with: model, withBadge: .views)
                    return cell
                }
        })

        dataSource?.supplementaryViewProvider = {
            [unowned self] (
                collection, kind, indexPath
            ) -> UICollectionReusableView? in

            if kind == UICollectionView.elementKindSectionHeader {

                guard let header = collectionView
                    .dequeueReusableSupplementaryView(
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
            return nil
        }

        DispatchQueue.main.async { [weak self] in
            self?.loader.stopLoader()

            UIView.animate(withDuration: 0.2) {
                collectionView.isHidden = false
                collectionView.alpha = 1
            }
            completion()
        }
    }

    func mbExploreViewNeedUpdate(_ collection: UICollectionView, 
                                 _ completion: @escaping (Bool) -> Void) {
        viewModel.fetchHomeData { success in
            if success {
                DispatchQueue.main.async { [unowned self] in
                    self.snapshot.reloadSections(
                        MBExploreViewViewModel.Sections.allCases
                    )
                }
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }

    private func applySnapshot() {
        MBExploreViewViewModel.Sections.allCases.forEach { [unowned self] section in
            snapshot.appendSections([section])
            snapshot.appendItems(
                viewModel.setupBooksCellModels(for: section),
                toSection: section
            )
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: COLLECTION VIEW DELEGATE

extension MBExploreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath) {
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
        var listVC: UIViewController

        switch section {
        case .categories:
            listVC = MBCategoriesListViewController()
        case .allBooks:
            listVC = MBBooksListViewController(selectedSeeAllSection: .all)
        case .mostViewed:
            listVC = MBBooksListViewController(selectedSeeAllSection: .popular)
        case .recentlyAdded:
            listVC = MBBooksListViewController(selectedSeeAllSection: .recently)
        }

        // MARK: REMOVE THIS SHIT
        viewModel.setSelectedSectionData(for: section)
        listVC.title = section.rawValue
        navigationController?.pushViewController(
            listVC, animated: true
        )
    }
}
