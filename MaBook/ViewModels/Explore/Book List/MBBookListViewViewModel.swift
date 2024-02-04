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

    public var allBooksData: BooksData? {
        didSet {
            guard let allBooksData else {return}
            books = allBooksData.books
            info = allBooksData.info
        }
    }

    private var info: Info?

    public var books = [Book]() {
        didSet {
            bookCellsModels = books.compactMap({
                return .init(identifier: UUID(), book: $0)
            })
        }
    }

    public var bookCellsModels = [MBBookEntityCellModel]()

    public func cellModel(_ identifier: UUID, for book: Book) -> MBBookEntityCellModel {
        return .init(
            identifier: UUID(),
            book: book
        )
    }

    @discardableResult
    public func appendModels(_ models: [Book]) -> [UUID] {
        books.append(contentsOf: models)
        let newModels = models.compactMap({
            return cellModel(UUID(), for: $0)
        })
        bookCellsModels.append(contentsOf: newModels)
        return newModels.map { $0.identifier }
    }

    public func updateModelIsAddedToCart(_ inCart: Bool, atIndex: Int) {
        books[atIndex].isAddedToCart = inCart
        bookCellsModels[atIndex].book.isAddedToCart = inCart
    }

    private lazy var configuredUrl: URL? = {
        guard let info, let url = info.currentPage,
                var components = URLComponents(string: url) else {
            return nil
        }
        let categoryQueryItem = components.queryItems?
            .first(where: {$0.name == "category"})
        components.queryItems = nil

        if var baseURL = components.url {
            baseURL.append(queryItems: [
                URLQueryItem(
                    name: "direction",
                    value: Self.selectedSortingType
                        .rawValue.uppercased()
                ),
                URLQueryItem(
                    name: "field",
                    value: "title"
                )
            ])
            if let categoryQueryItem {
                baseURL.append(
                    queryItems: [categoryQueryItem]
                )
            }
            return baseURL
        }
        else {
            MBLogger.shared.debugInfo(
                "vm: no url reference - unable to create base url"
            )
            return nil
        }
    }()


    public func fetchCategoriesBooks(
        for category: String,
        via url: URL? = nil,
        _ completion: @escaping (Bool, [Book]?
        ) -> Void = {_,_ in }) 
    {
        var request: MBRequest!
        if let url = url {
            request = MBRequest(url: url)
        }
        else {
            request = MBRequest(
                endpoint: .books,
                pathComponents: ["category"],
                queryParameters: [
                    URLQueryItem(name: "category", value: category)
                ]
            )
        }

        self.perform(request, receive: MBBooksSectionResponse.self) { [weak self] isSuccess, data in
            guard isSuccess, let data = data else {
                MBLogger.shared.debugInfo("vm: failed to retrieve more books data")
                completion(false, nil)
                return
            }
            self?.allBooksData = data.data
            completion(true, data.data.books)

        }
    }


    public func fetchInitialBooks(
        in section: MBEndpoint,
        _ completion: @escaping (Bool) -> Void
    ) {
        let request = MBRequest(
            endpoint: .books,
            pathComponents: [section.rawValue]
        )

        self.perform(request, receive: MBBooksSectionResponse.self) 
        { [weak self] isSuccess, data in
            guard isSuccess, let data = data else {
                return
            }
            self?.allBooksData = data.data
            completion(isSuccess)
        }
    }

    public func fetchInitialBooks(
        via url: URL,
        _ completion: @escaping () -> Void
    ) {
        guard let urlRequest = MBRequest(url: url) else {
            return
        }

        self.perform(urlRequest, receive: MBBooksSectionResponse.self)
        { [weak self] isSuccess, data in
            guard isSuccess, let data = data else {
                return
            }
            self?.allBooksData = data.data
            completion()
        }
    }


    public func fetchNextPageBooks(
        _ completion: @escaping (Bool, [UUID]?) -> Void
    ) {

        guard let info, let urlString = info.nextPage,
              let url = URL(string: urlString),
              let request = MBRequest(url: url)
        else {
            MBLogger.shared.debugInfo("vm: failed to get next page pagination link")
            completion(false, nil)
            return
        }

        self.perform(request, receive: MBBooksSectionResponse.self) { [weak self] isSuccess, data in
            guard isSuccess, let data = data else {
                return
            }
            self?.info = data.data.info
            let modelsIdentifiers = self?.appendModels(data.data.books)
            completion(isSuccess, modelsIdentifiers)
        }
    }

    public func performSorting(_ completion: @escaping (Bool) -> Void) {
        guard let url = self.configuredUrl,
              let request = MBRequest(url: url) else {
            return
        }
        
        self.perform(request, receive: MBBooksSectionResponse.self) { [weak self] isSuccess, data in
            guard isSuccess, let data = data else {
                MBLogger.shared.debugInfo("vm: failed to retrieve sorted books data")
                completion(false)
                return
            }
            self?.allBooksData = data.data
            Self.selectedSortingType = (Self.selectedSortingType == .asc) 
            ? .desc
            : .asc
            completion(isSuccess)
        }
    }

    public func addToCart(item: Book, _ completion: @escaping (Bool) -> Void) {
        let request = MBRequest(endpoint: .user, httpMethod: .post, pathComponents: ["basket"])
        let jsonBody = try? JSONEncoder().encode(item)

        self.perform(request, body: jsonBody, receive: MBAddToCartResponse.self) { success, result in
            guard success, let count = result?.count else {
                MBLogger.shared.debugInfo("list vm failed with adding to basket")
                completion(false)
                return
            }
            MBLogger.shared.debugInfo("list vm: successfuly add to basket")
            LocalStateManager.shared.cartItemsCount.send(String(count))
            completion(true)
        }
    }

    private func perform<T: Codable>(_ request: MBRequest, body: Data? = nil, receive type: T.Type,
                                     completion: @escaping (Bool, T?) -> Void) {

        MBApiCaller.shared.executeRequest(
            request, body: body, expected: type.self, shouldCache: false
        ) { result, statusCode in

            switch result {
            case .success(let success):
                completion(true, success)
            case .failure(let failure):
                MBLogger.shared.debugInfo("vm: failed to retrieve more books data")
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(false, nil)
            }

        }
    }
}
