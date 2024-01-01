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
        section.boundarySupplementaryItems = [createHomeSectionHeader()]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0)
        return section
    }


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
        groupHeightDimension: NSCollectionLayoutDimension
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
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0)
        return section
    }

    public func createHomeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let headerSupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        headerSupplementaryItem.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        return headerSupplementaryItem
    }
}
