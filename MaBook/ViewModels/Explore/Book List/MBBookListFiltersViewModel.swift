//
//  MBBookListFiltersViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 03.01.2024.
//

import Foundation

final class MBBookListFiltersViewModel {
    
    struct Section {
        var title: String
        let options: [String]?
        var isExpanded: Bool = false
        var minPrice: String? = nil
        var maxPrice: String? = nil
    }

    enum ExpandableCellType {
        case sectionCell
        case optionCell
    }

    enum Sections: CaseIterable {
        case available
        case categories
        case price
    }

    var currentSectionUrl: String {
        didSet {
            guard let url = URL(string: currentSectionUrl),
                  let components = URLComponents(
                    url: url,
                    resolvingAgainstBaseURL: true
                  )
            else {
                return
            }
            if let categoryQueryItem = components.queryItems?
                .first(where: {$0.name == "category"}) {
                self.categoryQueryItem = categoryQueryItem
                self.shouldShowCategories = false
            }
        }
    }

    private var categoryQueryItem: URLQueryItem?
    public private(set) var shouldShowCategories: Bool = true

    init(currentSection: String) {
        self.currentSectionUrl = currentSection
        self.shouldShowCategories = self
            .determineShouldShowCategories(
                from: currentSection
            )
        setupSections()
    }

    public var sections = [Section]()

    private func determineShouldShowCategories(from urlString: String) -> Bool {
        guard let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return true
        }

        if let categoryQueryItem = components.queryItems?
            .first(where: {
                $0.name == "category"
            }) {
            self.categoryQueryItem = categoryQueryItem
            return false
        }

        return true
    }


    private func setupSections() {
        if shouldShowCategories == false {
            sections = [
                .init(title: "Show only available books", options: nil),
                .init(title: "Point Range", options: ["textfiled cell"])
            ]
        }
        else {
            sections = [
                .init(title: "Show only available books", options: nil),
                .init(title: "Categories", options: LocalStateManager.shared
                    .categories.compactMap({ $0.name })),
                .init(title: "Point Range", options: ["textfiled cell"])
            ]
        }
    }

    public func filterBooks(
        byShowAvailable available: Bool?,
        inCategoty category: String?,
        minPrice: String?,
        maxPrice: String?,
        _ completion: @escaping (URL) -> Void
    ) {

        guard let url = URL(string: currentSectionUrl),
              var components = URLComponents(
                url: url, resolvingAgainstBaseURL: true
              )
        else {
            return
        }
        components.queryItems = []

        if let available = available {
            components.queryItems?.append(
                URLQueryItem(name: "available", value: String(available))
            )
        }
        if let minPrice = minPrice {
            components.queryItems?.append(
                URLQueryItem(name: "min", value: minPrice)
            )
        }
        if let maxPrice = maxPrice {
            components.queryItems?.append(
                URLQueryItem(name: "max", value: maxPrice)
            )
        }

        guard components.queryItems != nil else {
            MBLogger.shared.debugInfo(
                "filters vm: no filters were selected"
            )
            return
        }
        var urlForRequest = components.url

        if let category = category {
            urlForRequest?.append(
                queryItems: [URLQueryItem(name: "category", value: category)]
            )
        }
        else if let initialCategory = categoryQueryItem {
            urlForRequest?.append(queryItems: [initialCategory])
        }
        guard let generatedUrl = urlForRequest else {
            MBLogger.shared.debugInfo(
                "filter vm unable to create url for filtering"
            )
            return
        }
        completion(generatedUrl)
    }
}
