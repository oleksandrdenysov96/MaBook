//
//  MBSearchViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 06.01.2024.
//

import Foundation

class MBSearchViewModel {

    class Section {
        let header: String
        var results: [[String: String]]

        init(header: String, results: [[String: String]]) {
            self.header = header
            self.results = results
        }
    }

    enum SearchSections: CaseIterable {
        case books
        case authors
        case recentSearches
    }

    public let sections = SearchSections.allCases

    public lazy var recentSearchesData = Section(
        header: "Recent Searches", results: LocalStateManager.shared.recentSearches
    )


    public var searchBooksData = Section(
        header: "Books", results: [[:]]
    )

    public func fetchSearchResults(with input: String, 
                                   _ completion: @escaping (Bool) -> Void) {
        let query = URLQueryItem(name: "search", value: input)
        let request = MBRequest(
            endpoint: .books, pathComponents: ["search"],
            queryParameters: [query]
        )

        MBApiCaller.shared.executeRequest(
            request, expected: MBSearchResponse.self
        ) { [weak self] result, statusCode in

            switch result {
            case .success(let data):
                self?.searchBooksData.results.removeAll()
                let matchedBooks = data.data.searchResult

                if matchedBooks.isEmpty {
                    self?.searchBooksData.results = [["title": "No matches", "author": ""]]
                }
                else {
                    for book in matchedBooks {
                        let pair = [
                            "id": String(book.id),
                            "title": book.title,
                            "author": book.author
                        ]
                        self?.searchBooksData.results.append(pair)
                    }
                }
                completion(true)

            case .failure(let failure):
                MBLogger.shared.debugInfo("search vm: search request failed")
                MBLogger.shared.debugInfo("error - \(failure)")
                MBLogger.shared.debugInfo(
                    "statusCode - \(String(describing: statusCode))"
                )
                completion(false)
            }
        }
    }

    public func fetchBookDetails(bookId: String, _ completion: @escaping ([Books]?, Bool) -> Void) {
        let query = URLQueryItem(name: "id", value: bookId)

        let request = MBRequest(
            endpoint: .books,
            pathComponents: ["search", "user-selection"],
            queryParameters: [query]
        )

        MBApiCaller.shared.executeRequest(request, expected: MBSearchBookDetailsResponse.self) { result, statusCode in
            switch result {
            case .success(let data):
                completion(data.data.books, true)

            case .failure(let failure):
                MBLogger.shared.debugInfo(
                    "search vm: failed to request selected book data"
                )
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(nil, false)
            }
        }
    }

    public func fetchBooksList(bookIds: [String], _ completion: @escaping ([Books]?, Bool) -> Void) {
        let query = bookIds.compactMap {
            return URLQueryItem(name: "id", value: $0)
        }

        let request = MBRequest(
            endpoint: .books,
            pathComponents: ["search", "user-selection"],
            queryParameters: query
        )

        MBApiCaller.shared.executeRequest(request, expected: MBSearchBookDetailsResponse.self) { result, statusCode in
            switch result {
            case .success(let data):
                completion(data.data.books, true)

            case .failure(let failure):
                MBLogger.shared.debugInfo(
                    "search vm: failed to request list of see all"
                )
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(nil, false)
            }
        }
    }

    public func deleteUserHistory() {
        guard let user = LocalStateManager.shared.loggedUser else {
            return
        }
        let request = MBRequest(
            endpoint: .user, httpMethod: .patch, pathComponents: [String(user.id)]
        )
        let body = MBApiCaller.shared.requestBody(
            body: [
                "historySearches": []
            ]
        )

        MBApiCaller.shared.executeRequest(request, body: body, expected: MBGetUserResponse.self) { result, statusCode in
            switch result {
            case .success(let data):
                LocalStateManager.shared.loggedUser = data.data.user

            case .failure(let failure):
                MBLogger.shared.debugInfo(
                    "search vm: failed to request list of see all"
                )
                MBLogger.shared.debugInfo("error - \(failure)")
            }
        }
    }
}
