//
//  MBBookListViewViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 29.12.2023.
//

import Foundation


final class MBBookListViewViewModel {

    enum Sections {
        case list
    }

    enum SortDirection: String {
        case desc
        case asc
    }

    public static private(set) var selectedSortingType: SortDirection = .desc

    public var allBooksData: BooksData {
        guard let data = LocalStateManager.shared.allBooks else {
            MBLogger.shared.debugInfo(
                "list vm: failed to retrieve books data from LS"
            )
            return BooksData(
                books: [], info: Info(
                    currentPage: nil, nextPage: nil)
            )
        }
        books = data.books
        return data
    }

    private lazy var info: Info = {
        return allBooksData.info
    }()

    public lazy var books: [Books] = {
        return allBooksData.books
    }()

    private var clearURL: String {
        if let url = info.currentPage,
            var trimmedUrl = url.components(separatedBy: "?").first {

            switch Self.selectedSortingType {
            case .desc:
                trimmedUrl.append("?direction=DESC")
            case .asc:
                trimmedUrl.append("?direction=ASC")
            }
            trimmedUrl.append("&field=title")
            return trimmedUrl
        }
        MBLogger.shared.debugInfo(
            "vm: no url reference - unable to create base url"
        )
        return ""
    }



    public func fetchMoreBooks(_ completion: @escaping (Bool, [Books]?) -> Void) {
        guard let urlString = info.nextPage,
              let url = URL(string: urlString),
              let request = MBRequest(url: url)
        else {
            MBLogger.shared.debugInfo("vm: failed to get nexp page pagination link")
            completion(false, nil)
            return
        }

        MBApiCaller.shared.executeRequest(
            request, expected: MBBooksSectionResponse.self, shouldCache: false
        ) { [weak self] result, statusCode in
            guard let self = self else {return}

            switch result {
            case .success(let success):
                self.info = success.data.info
                completion(true, success.data.books)
                

            case .failure(let failure):
                MBLogger.shared.debugInfo("vm: failed to retrieve more books data")
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(false, nil)
            }

        }
    }

    public func performSorting(_ completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: clearURL),
              let request = MBRequest(url: url) else {
            return
        }

        MBApiCaller.shared.executeRequest(
            request, expected: MBBooksSectionResponse.self
        ) { [weak self] result, statusCode in

            switch result {
            case .success(let success):
                self?.books = success.data.books
                self?.info = success.data.info

                if Self.selectedSortingType == .asc {
                    Self.selectedSortingType = .desc
                }
                else {
                    Self.selectedSortingType = .asc
                }
                completion(true)
            case .failure(let failure):
                MBLogger.shared.debugInfo("vm: failed to retrieve sorted books data")
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(false)
            }
        }
    }

}
