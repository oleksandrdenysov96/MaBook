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

        self.itemInsets(item: item, top: 0, leading: 6, bottom: 3, trailing: 6)


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

    public func itemInsets(item: NSCollectionLayoutItem, top: CGFloat,
                           leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {

        item.contentInsets = NSDirectionalEdgeInsets(
            top: top, leading: leading, bottom: bottom, trailing: trailing
        )
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
