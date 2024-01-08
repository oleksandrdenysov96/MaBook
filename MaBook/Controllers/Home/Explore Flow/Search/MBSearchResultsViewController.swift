//
//  MBSearchResultsViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 05.01.2024.
//

import UIKit

class MBSearchResultsViewController: UIViewController {

    private let searchView = MBSearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(searchView)
        searchView.backgroundColor = .red
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }


}
