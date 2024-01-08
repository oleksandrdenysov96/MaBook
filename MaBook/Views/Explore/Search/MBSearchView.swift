//
//  MBSearchView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 05.01.2024.
//

import UIKit

protocol MBSearchViewDelegate: AnyObject {
    func mbSearchView(needsConfigure table: UITableView)
}

class MBSearchView: UIView {

    public weak var delegate: MBSearchViewDelegate?

    private let tableView: UITableView = {
        let table  = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
        tableView.leftAnchor.constraint(equalTo: leftAnchor),
        tableView.rightAnchor.constraint(equalTo: rightAnchor),
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    public func setupTable() {
        delegate?.mbSearchView(needsConfigure: tableView)
    }

}
