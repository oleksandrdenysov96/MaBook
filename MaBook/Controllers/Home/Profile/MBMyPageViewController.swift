//
//  MBMyPageViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 25.12.2023.
//

import UIKit

class MBMyPageViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

}
