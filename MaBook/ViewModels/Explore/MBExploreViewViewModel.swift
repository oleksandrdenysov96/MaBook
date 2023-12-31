//
//  MBExploreViewViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import UIKit
import Foundation

enum MBHomeSections: String, CaseIterable {
    case categories = "Categories"
    case allBooks = "All Books"
    case recentlyAdded = "Recently Added"
    case mostViewed = "Most Viewed"
}

final class MBExploreViewViewModel {

    public let sections = MBHomeSections.allCases

    private let layout = MBCompositionalLayout()

    public var responseData: MBBooksHomeResponse? {
        didSet {
            guard let data = responseData else {
                MBLogger.shared.debugInfo("vm: books isn't retrieved")
                return
            }
            categories = data.data.categories
            allBooks = data.data.allBooks
            recentlyAdded = data.data.recentlyAdded
            mostViewed = data.data.mostViewed
        }
    }
    public var categories: [Categories] = []
    public var allBooks: BooksData?
    public var recentlyAdded: BooksData?
    public var mostViewed: BooksData?

    public func fetchHomeData(_ completion: @escaping (Bool) -> Void) {
        let request = MBRequest(endpoint: .books, pathComponents: ["home"])

        MBApiCaller.shared.executeRequest(
            request, expected: MBBooksHomeResponse.self, shouldCache: false
        ) { result, statusCode in

            switch result {
            case .success(let response):
                self.responseData = response
                LocalStateManager.shared.booksData = response.data
                completion(true)
            case .failure(let failure):
                MBLogger.shared.debugInfo("explore vm: failed to retrieve response for home data")
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(false)
            }
        }
    }


    // Home data && User data
    public func performMainRequests(_ completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()

        group.enter()
        fetchHomeData { success in
            completion(success)
            group.leave()
        }

        group.enter()
        AuthManager.shared.getUser { success in
            if success {
                MBLogger.shared.debugInfo("user data is received")
            }
            else {
                MBLogger.shared.debugInfo("failed to get user data on homepage")
            }
            group.leave()
        }
    }

    public func createSectionLayout(for section: Int) -> NSCollectionLayoutSection {
        let sections: [MBHomeSections] = [.categories, .allBooks, .recentlyAdded, .mostViewed]

        switch sections[section] {
        case .categories:
            return layout.createHomeSectionLayout(
                itemWidthDimension: .absolute(120),
                itemHeightDimension: .absolute(110),
                groupWidthDimension: .absolute(120),
                groupHeightDimension: .absolute(110)
            )
        case .allBooks, .recentlyAdded, .mostViewed:
            return layout.createHomeSectionLayout(
                itemWidthDimension: .absolute(140),
                itemHeightDimension: .absolute(220),
                groupWidthDimension: .absolute(140),
                groupHeightDimension: .absolute(230)
            )
        }
    }

    public func dequeueCellFor(
        _ collectionView: UICollectionView,
        index: IndexPath,
        badgeType: CellBadgeType,
        badgeText: String? = nil,
        price: String,
        bookTitle: String,
        bookImage: String,
        genre: String
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MBBookCollectionViewCell.cellIdentifier,
            for: index
        ) as? MBBookCollectionViewCell else {
            MBLogger.shared.debugInfo("vc: failed to create categories cell")
            fatalError()
        }
        cell.configure(
            badgeType: badgeType,
            badgeText: badgeText,
            price: price,
            bookTitle: bookTitle,
            bookImage: bookImage,
            genre: genre
        )
        return cell
    }

    public func setSelectedSectionData(for section: MBHomeSections) {
        switch section {
        case .allBooks:
            LocalStateManager.shared.selectedCategoryData = allBooks
        case .recentlyAdded:
            LocalStateManager.shared.selectedCategoryData = recentlyAdded
        case .mostViewed:
            LocalStateManager.shared.selectedCategoryData = mostViewed
        default:
            return
        }
    }
}
