//
//  MBCompositionalLayout.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 27.12.2023.
//

import UIKit
import Foundation

class MBCompositionalLayout {


    public func createHomeSectionLayout(
        itemWidthDimension: NSCollectionLayoutDimension,
        itemHeightDimension: NSCollectionLayoutDimension,
        groupWidthDimension: NSCollectionLayoutDimension,
        groupHeightDimension: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: itemWidthDimension, heightDimension: itemHeightDimension)
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 6, bottom: 3, trailing: 6
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: groupWidthDimension,
                                               heightDimension: groupHeightDimension),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createHomeSectionHeader(withHeight: 60)]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0)
        return section
    }

    
    // MARK: BOOK DETAILS

    public func createBookPhotoDetailsLayout(
        itemWidthDimension: NSCollectionLayoutDimension,
        itemHeightDimension: NSCollectionLayoutDimension,
        groupWidthDimension: NSCollectionLayoutDimension,
        groupHeightDimension: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: itemWidthDimension, heightDimension: itemHeightDimension)
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 6, bottom: 0, trailing: 6
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: groupWidthDimension,
                                               heightDimension: groupHeightDimension),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 5
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0)
        return section
    }

    public func createBaseLayout(
        itemWidthDimension: NSCollectionLayoutDimension,
        itemHeightDimension: NSCollectionLayoutDimension,
        groupWidthDimension: NSCollectionLayoutDimension,
        groupHeightDimension: NSCollectionLayoutDimension,
        sectionTopInset: CGFloat = 0,
        sectionLeftInset: CGFloat = 0,
        sectionRightInset: CGFloat = 0,
        sectionBottomInset: CGFloat = 0
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: itemWidthDimension, heightDimension: itemHeightDimension)
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 25, bottom: 0, trailing: 25
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: groupWidthDimension,
                                               heightDimension: groupHeightDimension),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: sectionTopInset,
            leading: sectionLeftInset,
            bottom: sectionBottomInset,
            trailing: sectionRightInset
        )
        return section
    }

    public func createHomeSectionHeader(withHeight height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(height)
        )
        let headerSupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        headerSupplementaryItem.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        return headerSupplementaryItem
    }

    // MARK: PROFILE:

    public func createProfileSectionLayout(
        groupWidthDimension: NSCollectionLayoutDimension,
        groupHeightDimension: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 10, bottom: 0, trailing: 10
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: groupWidthDimension,
                                               heightDimension: groupHeightDimension),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
