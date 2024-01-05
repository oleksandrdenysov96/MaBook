//
//  MBBooksListFilterView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 29.12.2023.
//

import UIKit

protocol MBBooksListFilterViewDelegate: AnyObject {
    func mbBooksListFilterView(needsConfigure table: UITableView)
    func mbBooksListFilterViewDidTapDoneButton()
}

class MBBooksListFilterView: UIView {

    public weak var delegate: MBBooksListFilterViewDelegate?

    private let doneButton: MBButton = {
        return MBButton(title: "Done")
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(views: tableView, doneButton)
        setupConstraint()

        doneButton.addTarget(
            self, action: #selector(didTapDone), for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureTable() {
        delegate?.mbBooksListFilterView(needsConfigure: tableView)
    }

    public func resetTable() {
        let fieldsSection = tableView.numberOfSections - 1
        let fieldCell = tableView.numberOfRows(inSection: fieldsSection) - 1
        
        guard let cell = tableView.cellForRow(
            at: IndexPath(row: fieldCell, section: fieldsSection)
        ) as? MBBookFilterTextFiledCell else {
            return
        }
        cell.maxField.text = nil
        cell.minField.text = nil
        
        tableView.reloadData()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20),

            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70)
        ])
    }

    @objc private func didTapDone() {
        delegate?.mbBooksListFilterViewDidTapDoneButton()
    }

}
