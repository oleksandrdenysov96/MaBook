//
//  MBOnboardingListView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 25.12.2023.
//

import UIKit

class MBOnboardingListView: UIView {

    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    public let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubviews(views: searchBar)
        addSubviews(views: tableView)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureView(by vc: MBOnboardingListViewController) {
        tableView.delegate = vc
        tableView.dataSource = vc
        searchBar.delegate = vc
        tableView.reloadData()
    }

    public func reloadTableData() {
        tableView.reloadData()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 90),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 1),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}
