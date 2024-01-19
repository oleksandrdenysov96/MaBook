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
        view.addSubview(collectionView)
        configureCollection()
        applySnapshot()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }

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
                cell.configure(username: model.title, id: model.id)

                cell.tapSubject.sink {
                    self.initiateAvatarFlow()
                    self.selectedImage.sink { image in
                        cell.avatarImage.send(image)
                    }
                    .store(in: &self.cancellables)
                }
                .store(in: &self.cancellables)

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


    private func initiateAvatarFlow() {
        print("avatar tapped")
        present(imagePicker, animated: true)
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
                let favoritesListVC = MBBooksListViewController()
                favoritesListVC.title = "Favorites"
                navigationController?.pushViewController(favoritesListVC, animated: true)

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
}


extension MBMyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            self.selectedImage.send(selectedImage)
        }

        dismiss(animated: true)
    }


}



