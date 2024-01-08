//
//  MBSearchViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 05.01.2024.
//

import UIKit

class MBSearchViewController: UISearchController, UISearchResultsUpdating {

    private let viewModel = MBSearchViewModel()
    private var selectedBookId: String?
    private var seeAllBooksIds = [String]()

    private let tableView: UITableView = {
        let table  = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var inputForSearch: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)

        searchBar.placeholder = "Book name or author name"
        searchResultsUpdater = self

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.alpha = 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.alpha = 0
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15
            ),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        inputForSearch = text

        if inputForSearch.count >= 2 {
            viewModel.fetchSearchResults(with: inputForSearch) { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        viewModel.searchBooksData.results.removeAll()
        tableView.reloadData()
    }

    private func showBookDetailsView(_ completion: @escaping () -> Void) {
        guard let bookId = selectedBookId else {
            return
        }
        viewModel.fetchBookDetails(bookId: bookId) { [weak self] books, success in
            if success {
                guard let books = books, let book = books.first else {
                    return
                }

                DispatchQueue.main.async {
                    let bookDetailsVC = MBBookDetailsViewController(with: book)
                    self?.presentingViewController?.navigationController?
                        .pushViewController(bookDetailsVC, animated: true)
                    completion()
                }
            }
        }
    }

    private func showBooksList() {
        viewModel.fetchBooksList(bookIds: seeAllBooksIds) { [weak self] books, success in
            if success {
                guard let books = books else {
                    return
                }

                DispatchQueue.main.async {
                    let booksListVC = MBBooksListViewController(selectedBooks: books)
                    booksListVC.title = MBHomeSections.allBooks.rawValue
                    self?.presentingViewController?.navigationController?
                        .pushViewController(booksListVC, animated: true)
                }
            }
        }
    }

    @objc private func didClose() {
        dismiss(animated: true)
    }
}

extension MBSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func actualSearchData() -> MBSearchViewModel.Section {
        return inputForSearch.isEmpty ? viewModel.recentSearchesData : viewModel.searchBooksData
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actualSearchData().results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MBSearchTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        
        if indexPath.row < self.actualSearchData().results.count {
            if let title = self.actualSearchData().results[indexPath.row]["title"],
               let author = self.actualSearchData().results[indexPath.row]["author"] {
                cell.configure(title: title, author: author)
            }
            else {
                cell.configure(title: "No Results", author: "")
            }
        }
        else {
//            if viewModel.recentSearchesData.results.count >= 2 {
            cell.configure(title: "", author: "")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if !inputForSearch.isEmpty {
            selectedBookId = viewModel.searchBooksData.results[indexPath.row]["id"]

            showBookDetailsView() { [weak self] in
                guard let self = self else { return }
                self.viewModel.recentSearchesData.results.removeAll { $0.isEmpty }

                if self.viewModel.recentSearchesData.results.count > 6 {
                    self.viewModel.recentSearchesData.results.removeFirst()
                }

                if !self.viewModel.recentSearchesData.results
                    .contains(self.viewModel.searchBooksData.results[indexPath.row]) {
                    self.viewModel.recentSearchesData.results.append(
                        self.viewModel.searchBooksData.results[indexPath.row]
                    )
                }
            }
        }
        else {
            if !viewModel.recentSearchesData.results.isEmpty &&
                viewModel.recentSearchesData.results[indexPath.row]["id"] != nil {
                selectedBookId = viewModel.recentSearchesData.results[indexPath.row]["id"]
                
                showBookDetailsView() {}
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MBTableHeaderReusableView(
            frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50)
        )
        view.delegate = self
        view.configureHeaderTitle(withText: self.actualSearchData().header)
        if self.actualSearchData().header == "Books" {

            view.configureHeaderButton(
                withText: "See All",
                isDestructive: false,
                shouldShow: !inputForSearch.isEmpty
            )
            view.tag = 1
        }
        else {
            if let emptyElement = viewModel.recentSearchesData.results.first {
                view.configureHeaderButton(
                    withText: "Delete history",
                    isDestructive: true,
                    shouldShow: !emptyElement.isEmpty
                )
            }
            else {
                view.configureHeaderButton(
                    withText: "Delete history",
                    isDestructive: true,
                    shouldShow: false
                )
            }
            view.tag = 0
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension MBSearchViewController: MBTableHeaderReusableViewDelegate {

    func mbTableHeaderReusableViewDidTapButton(_ headerView: MBTableHeaderReusableView) {
        if headerView.tag == 0 {
            presentMultiOptionAlert(
                message: "This will erase all history results",
                actionTitle: "Delete",
                buttonTitle: "Cancel"
            ) { [weak self] in
                guard let self = self else { return }
                self.viewModel.recentSearchesData
                    .results.removeAll()
                self.viewModel.deleteUserHistory()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
            }
        }
        else {
            seeAllBooksIds = viewModel.searchBooksData
                .results.compactMap {
                    return $0["id"]
                }
            showBooksList()
        }
    }
    


}
