//
//  MBBookFilterViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 03.01.2024.
//

import UIKit



class MBBookFilterViewController: UIViewController {

    private let selectionBlock: ((URL) -> Void)

    // MARK: FILTERS TO SELECT:
    private var showAvailable = false

    private var selectedCategory: String?
    private var minPrice: String?
    private var maxPrice: String?

    private let viewModel: MBBookListFiltersViewModel
    private let filterView = MBBooksListFilterView()

    private lazy var actualSections: [MBBookListFiltersViewModel.Sections] = {
        var sections = MBBookListFiltersViewModel.Sections.allCases

        if viewModel.sections.first(where: { $0.title == "Categories" }) == nil {
            sections.remove(at: 1)
        }
        return sections
    }()

    init(inititalData: String, selection: @escaping (URL) -> Void) {
        self.viewModel = .init(currentSection: inititalData)
        self.selectionBlock = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(filterView)
        filterView.delegate = self
        filterView.configureTable()

        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        setupNavBarControls()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupDedicatedView(filterView)
    }

    private func setupNavBarControls() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Reset", 
            style: .plain,
            target: self,
            action: #selector(didTapReset)
        )
        navigationItem.leftBarButtonItem?.tintColor = .systemRed

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }


    @objc private func didTapReset() {
        showAvailable = false

        for section in 0..<viewModel.sections.count {
            viewModel.sections[section].isExpanded = false
            viewModel.sections[section].maxPrice = nil
            viewModel.sections[section].minPrice = nil

            if section == 1 {
                viewModel.sections[section].title = "Categories"
            }
        }
        filterView.resetTable()
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}


extension MBBookFilterViewController: MBBooksListFilterViewDelegate {
    func mbBooksListFilterViewDidTapDoneButton() {
        viewModel.filterBooks(
            byShowAvailable: showAvailable,
            inCategoty: selectedCategory,
            minPrice: minPrice,
            maxPrice: maxPrice
        ) { [weak self] filtersUrl in
            self?.selectionBlock(filtersUrl)
            self?.dismiss(animated: true)
        }
    }
    
    func mbBooksListFilterView(needsConfigure table: UITableView) {
        table.delegate = self
        table.dataSource = self
    }
}

extension MBBookFilterViewController: UITableViewDelegate, UITableViewDataSource {


    func numberOfSections(in tableView: UITableView) -> Int {
        return actualSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch actualSections[section] {
        case .available:
            return 1
        case .categories, .price:
            return viewModel.sections[section].isExpanded ?
            viewModel.sections[section].options!.count + 1 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch actualSections[indexPath.section] {

            // MARK: TOGGLE CELL
        case .available:
            let cell: MBBookListFilterAvailableCell = tableView
                .dequeueReusableCell(for: indexPath)
            cell.configure(titleData: viewModel.sections[indexPath.section].title)
            cell.accessoryView = nil

            if let toggle = cell.accessoryView as? UISwitch {
                toggle.removeFromSuperview()
            }
            let toggle = UISwitch()
            toggle.isOn = showAvailable
            toggle.onTintColor = .systemCyan
            toggle.thumbTintColor = .white
            toggle.addTarget(
                self, action: #selector(didToggleSwitch(_:)),
                for: .valueChanged
            )
            cell.accessoryView = toggle
            return cell
            

            // MARK: CATEGORIES CELL
        case .categories:
            guard let options = viewModel.sections[indexPath.section].options else {
                fatalError("no cell datasource")
            }
            var cell: MBBookListFilterExpandableCell?
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(for: indexPath)
                cell?.configure(withType: .sectionCell, withText: viewModel.sections[indexPath.section].title)
            }
            else {
                cell = tableView.dequeueReusableCell(for: indexPath)
                cell?.configure(withType: .optionCell, withText: options[indexPath.row - 1])
            }

            if indexPath.row != 0 {
                if let selectedCategory = selectedCategory {
                    if viewModel.sections[indexPath.section]
                        .options![indexPath.row - 1] == selectedCategory {
                        cell?.accessoryType = .checkmark
                        cell?.accessoryView?.tintColor = .gray
                    }
                }
            }

            guard let cell = cell else { fatalError() }
            return cell


            // MARK: PRICE CELL
        case .price:
            if indexPath.row == 0 {
                let cell: MBBookListFilterExpandableCell = tableView
                    .dequeueReusableCell(for: indexPath)
                cell.configure(withType: .sectionCell, withText: viewModel.sections[indexPath.section].title)
                return cell
            }
            else {
                let cell: MBBookFilterTextFiledCell = tableView
                    .dequeueReusableCell(for: indexPath)
                cell.configurePlaceholder()

                cell.minFieldValueChanged = { [weak self] text in
                    self?.viewModel.sections[indexPath.section].minPrice = text
                    self?.minPrice = text
                }
                cell.maxFieldValueChanged = { [weak self] text in
                    self?.viewModel.sections[indexPath.section].maxPrice = text
                    self?.maxPrice = text
                }
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch actualSections[indexPath.section] {
        case .available:
            break
        case .categories:
            if indexPath.row != 0 {
                if viewModel.sections[indexPath.section]
                    .options![indexPath.row - 1] != selectedCategory {

                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    tableView.cellForRow(at: indexPath)?.accessoryView?.tintColor = .black
                    selectedCategory = viewModel.sections[indexPath.section]
                        .options![indexPath.row - 1]
                    viewModel.sections[indexPath.section].title = selectedCategory!

                }
                else {
                    viewModel.sections[indexPath.section].title = "Categories"
                    tableView.cellForRow(at: indexPath)?.accessoryView = nil
                    selectedCategory = nil
                }
            }
            viewModel.sections[indexPath.section].isExpanded.toggle()
            tableView.reloadSections([indexPath.section], with: .none)

        case .price:
            viewModel.sections[indexPath.section].isExpanded.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }


    @objc private func didToggleSwitch(_ sender: UISwitch) {
        showAvailable = sender.isOn
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

