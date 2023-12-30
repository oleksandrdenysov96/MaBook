//
//  MBOnboardingListViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 24.12.2023.
//

import UIKit

protocol MBOnboardingListViewControllerDelegate: AnyObject {
    func shouldBeDismissedWithSelection(item: String?)
}

class MBOnboardingListViewController: UIViewController {

    public weak var delegate: MBOnboardingListViewControllerDelegate?
    private let listView = MBOnboardingListView()

    private let initialData: [String: [String]]
    private var data: [String: [String]]
    private var selectedItem: String?

    init(data: [String: [String]]) {
        self.data = data
        self.initialData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(listView)
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.searchBar.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(didTapClose)
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listView.leftAnchor.constraint(equalTo: view.leftAnchor),
            listView.rightAnchor.constraint(equalTo: view.rightAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func dataValuesForIndex(_ index: Int) -> [String] {
        let keys = data.sorted(by: { $0.key < $1.key })
        let key = keys[index]
        let valuesForSection = data[key.key] ?? []
        return valuesForSection
    }
    
    @objc private func didTapClose() {
        delegate?.shouldBeDismissedWithSelection(item: selectedItem)
    }
}


extension MBOnboardingListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataValuesForIndex(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let value = dataValuesForIndex(indexPath.section)[indexPath.row]
        cell.textLabel?.text = value
        cell.indentationLevel = 2
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath),
              let cellText = cell.textLabel?.text else {
            MBLogger.shared.debugInfo("no string from cell")
            return
        }
        selectedItem = cellText
        delegate?.shouldBeDismissedWithSelection(item: selectedItem)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if data.sorted(by: { $0.key < $1.key })[section].value.isEmpty {
            return nil
        }
        else {
            return data.sorted(by: { $0.key < $1.key })[section].key
        }
    }
}

extension MBOnboardingListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var newDictionary: [String: [String]] = [:]

        for (key, value) in initialData {
            newDictionary[key] = searchText.isEmpty ? value : value.filter({(dataString: String) -> Bool in
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })
        }
        data = searchText.isEmpty ? initialData : newDictionary
        listView.tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        listView.searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        data = initialData
        listView.tableView.reloadData()
    }

}
