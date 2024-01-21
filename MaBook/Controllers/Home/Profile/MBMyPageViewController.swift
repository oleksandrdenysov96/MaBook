//
//  MBMyPageViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 25.12.2023.
//
import Combine
import UIKit

fileprivate typealias DataSource = UICollectionViewDiffableDataSource<
    MBProfileViewModel.Sections, AnyProfileCell
>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<
    MBProfileViewModel.Sections, AnyProfileCell
>

class MBMyPageViewController: UIViewController, UICollectionViewDelegate {

    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()

    private let viewModel = MBProfileViewModel()
    private let layout = MBCompositionalLayout()
    private var cancellables = Set<AnyCancellable>()
    private let imagePicker = UIImagePickerController()
    private let selectedImage = CurrentValueSubject<UIImage?, Never>(nil)
    private let loader = MBLoader()


    private let collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(
            MBProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: MBProfileCollectionViewCell
                .identifier
        )
        collection.register(
            MBHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: MBHeaderCollectionReusableView
                .identifier
        )
        return collection

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(
            views: collectionView, loader
        )
        configureCollection()
        applySnapshot()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        viewModel.fetchFavorites()
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func configureCollection() {
        let layout = UICollectionViewCompositionalLayout { [weak self] (section, _) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch section {
            case 0:
                return self.layout.createProfileSectionLayout(
                    groupWidthDimension: .fractionalWidth(1.0),
                    groupHeightDimension:  .absolute(185)
                )
            default:
                let config = self.layout.createProfileSectionLayout(
                    groupWidthDimension: .fractionalWidth(1.0),
                    groupHeightDimension:  .absolute(65)
                )
                config.boundarySupplementaryItems = [self.layout.createHomeSectionHeader(withHeight: 45)]
                return config
            }
        }

        collectionView.collectionViewLayout = layout
        collectionView.register(
            MBHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MBHeaderCollectionReusableView.identifier
        )
        collectionView.delegate = self

        dataSource = DataSource(collectionView: collectionView, cellProvider: {
            [weak self] (collectionView, indexPath, item) -> UICollectionViewCell in
            guard let self = self else { fatalError() }
            switch indexPath.section {
            case 0:
                guard let model = item.base as? MBUserInfoCellViewModel else {
                    MBLogger.shared.debugInfo("unable to parce userInfo model")
                    fatalError()
                }
                let cell: MBUserInfoCollectionViewCell = collectionView
                    .dequeueReusableCell(for: indexPath)
                cell.configure(
                    username: model.title,
                    id: model.id
                )

                cell.tapSubject.flatMap { _ -> AnyPublisher<UIImage?, Never> in
                    return self.initiateAvatarFlow()
                }
                .sink { image in
                    cell.avatarImage.send(image)
                }
                .store(in: &cancellables)
                return cell

            default:
                guard let model = item.base as? MBGenericProfileCellViewModel else {
                    MBLogger.shared.debugInfo("unable to parce activities or settings")
                    fatalError()
                }
                let cell: MBProfileCollectionViewCell = collectionView
                    .dequeueReusableCell(for: indexPath)
                cell.configure(
                    with: model.title,
                    isDestructive: model.title.isEqual(
                        MBProfileViewModel.ProfileItemTitle.logout.rawValue
                    )
                )
                return cell
            }
        })

        dataSource?.supplementaryViewProvider = { 
            (collection, kind, indexPath) -> UICollectionReusableView? in

            if indexPath.section != 0 && kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collection.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MBHeaderCollectionReusableView.identifier,
                    for: indexPath
                ) as? MBHeaderCollectionReusableView
                else {
                    fatalError()
                }

                headerView.backgroundColor = UIColor(
                    red: 0.98, green: 0.98, blue: 0.98, alpha: 1
                )
                headerView.configureHeader(
                    with: indexPath.section == 1 ? "Your Activity" : "Settings"
                )
                headerView.title.font = .systemFont(ofSize: 16, weight: .bold)
                return headerView
            }
            return nil
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func applySnapshot() {
        for section in MBProfileViewModel.Sections.allCases {
            dataSourceSnapshot.appendSections([section])

            switch section {
            case .userInfo:
                dataSourceSnapshot.appendItems(
                    viewModel.infoItems, toSection: section
                )
            case .activity:
                dataSourceSnapshot.appendItems(
                    viewModel.activityItems, toSection: section
                )
            case .settings:
                dataSourceSnapshot.appendItems(
                    viewModel.settingsItems, toSection: section
                )
            }
        }
        dataSource?.apply(dataSourceSnapshot)
    }


    private func initiateAvatarFlow() -> AnyPublisher<UIImage?, Never> {
        MBLogger.shared.debugInfo("vc: avatar tapped")
        let actionSheet = UIAlertController(
            title: "Edit photo",
            message: "Select new photo from your gallery",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        actionSheet.addAction(
            UIAlertAction(title: "Select Photo", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                present(self.imagePicker, animated: true)
            })
        )
        present(actionSheet, animated: true)
        return selectedImage.eraseToAnyPublisher()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let rows = MBProfileViewModel.ProfileItemTitle.self

        if indexPath.section != 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? MBProfileCollectionViewCell else {
                return
            }

            switch cell.cellTitle.text {

            case rows.favorites.rawValue:
                if LocalStateManager.shared.shouldFetchFavorites {
                    loader.startLoader()
                    viewModel.fetchFavorites() { [weak self] books in
                        guard let books = books else {
                            return
                        }
                        DispatchQueue.main.async {
                            self?.loader.stopLoader()
                            self?.displayFavoritesPage(with: books)
                        }
                        LocalStateManager.shared
                            .shouldFetchFavorites = false
                    }
                }
                else {
                    displayFavoritesPage(with: viewModel.favorites)
                }

            case rows.exchangedBooks.rawValue:
                break

            case rows.purchasedBooks.rawValue:
                break

            case rows.logout.rawValue:
                presentMultiOptionAlert(message: "Want to logout?", actionTitle: "Yes", buttonTitle: "Cancel") {

                }
            default:
                break
            }
        }
    }

    private func displayFavoritesPage(with data: [Book]) {
        let favoritesListVC = MBBooksListViewController(
            selectedBooks: data
        )
        favoritesListVC.title = "Favorites"
        navigationController?.pushViewController(favoritesListVC, animated: true)
    }
}


extension MBMyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            let avatarData = selectedImage.jpegData(compressionQuality: 0.7)
            viewModel.postAvatarData(avatarData) { [weak self] success in
                if success {
                    self?.selectedImage.send(selectedImage)
                }
                else {
                    self?.presentSingleOptionErrorAlert(
                        message: "We have an error with uploading your avatar"
                    )
                }
            }
        }
        dismiss(animated: true)
    }


}



