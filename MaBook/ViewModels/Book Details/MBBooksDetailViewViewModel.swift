//
//  MBBooksDetailViewViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 31.12.2023.
//

import Combine
import UIKit
import Foundation


final class MBBooksDetailViewViewModel {

    enum SectionCellType: CaseIterable {
        case photo
        case summary
        case condition
        case pages
        case dimensions
    }

    enum Items: Hashable {
        case photoCell(MBPhotoSectionViewModel)
        case summaryCell(MBSummarySectionViewModel)
        case conditionCell(MBInfoSectionViewModel)
        case pagesCell(MBInfoSectionViewModel)
        case dimensionsCell(MBInfoSectionViewModel)
    }


    private var data: Book
    public var isFavorite = CurrentValueSubject<Bool, Never>(false)

    public var sections: [SectionCellType] {
        return SectionCellType.allCases
    }
    public var items = [Items]()
    public var photoItems = [Items]()

    private let layout = MBCompositionalLayout()

    init(with data: Book) {
        self.data = data
        retrieveCellItems()
    }

    public func fetchSecondaryData(_ completion: @escaping (Book) -> Void) {
        let request = MBRequest(endpoint: .books, pathComponents: [String(data.id)])

        MBApiCaller.shared.executeRequest(request, expected: MBBookDetailsResponse.self) { [weak self] result, statusCode in
            switch result {
            case .success(let data):
                self?.data = data.data
                self?.isFavorite.value = data.data.isFavorite
                completion(data.data)
            case .failure(let failure):
                MBLogger.shared.debugInfo("failure - \(failure)")
            }
        }
    }

    private func retrieveCellItems() {
        photoItems = data.images.compactMap {
            return Items.photoCell(.init(imageURL: $0))
        }
        items = [
            .summaryCell(.init(title: data.title, author: data.author, summary: data.description, genre: data.genre)),
            .conditionCell(.init(infoParam: "Condition:", value: data.condition)),
            .pagesCell(.init(infoParam: "Pages:", value: String(data.pages))),
            .dimensionsCell(.init(infoParam: "Dimensions:", value: data.dimensions))
        ]
    }

    public func updateFavoritesForBook(action: MBRequest.HttpMethod, body: Book? = nil, id: String? = nil) {
        if action == .post {
            guard let body = body else {
                MBLogger.shared.debugInfo("no body for update favorites")
                return
            }
            let request = MBRequest(
                endpoint: .user,
                httpMethod: .post,
                pathComponents: ["favorites"]
            )
            let bodyData = try? JSONEncoder().encode(body)

            MBApiCaller.shared.executeRequest(
                request, body: bodyData, expected: Dictionary<String, Int>.self
            ) { _, _ in }
        }
        else if action == .delete {
            guard let id = id else {
                MBLogger.shared.debugInfo("no id for update favorites")
                return
            }
            let request = MBRequest(
                endpoint: .user,
                httpMethod: .delete,
                pathComponents: ["favorites", id]
            )
            MBApiCaller.shared.executeRequest(
                request, expected: Dictionary<String, Int>.self
            ) { _, _ in }
        }
    }

    public func createLayout(for section: Int) -> NSCollectionLayoutSection {
        switch sections[section] {
        case .photo:
            return layout.createBookPhotoDetailsLayout(
                itemWidthDimension: .absolute(310),
                itemHeightDimension: .absolute(310),
                groupWidthDimension: .absolute(310),
                groupHeightDimension: .absolute(310)
            )
        case .summary:
            return layout.createBaseLayout(
                itemWidthDimension: .fractionalWidth(1.0),
                itemHeightDimension: .absolute(270),
                groupWidthDimension: .fractionalWidth(1.0),
                groupHeightDimension: .absolute(310)
            )
        case .condition, .dimensions, .pages:
            return layout.createBaseLayout(
                itemWidthDimension: .fractionalWidth(1.0),
                itemHeightDimension: .absolute(25),
                groupWidthDimension: .fractionalWidth(1.0),
                groupHeightDimension: .absolute(25)
            )
        }
    }
}



//
//          COMBINE LOGIC
//
//    public func fetchPrice() -> Future<Books, Error> {
//        let request = MBRequest(endpoint: .books, pathComponents: [String(data.id)])
//        return Future { [weak self] promise in
//            guard let self = self else {return}
//            MBApiCaller.shared.exectuteCMBRequest(request, expected: Books.self)
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        MBLogger.shared.debugInfo(
//                            "success: vm ended successfully with combine request"
//                        )
//                        MBLogger.shared.debugInfo("request - \(String(describing: request.url))")
//                    case .failure(let failure):
//                        MBLogger.shared.debugInfo(
//                            "end: vm ended with failure with combine request"
//                        )
//                        MBLogger.shared.debugInfo("request - \(String(describing: request.url))")
//                        promise(.failure(failure))
//                    }
//                }, receiveValue: { [weak self] book in
//                    self?.data = book
//                    promise(.success(book))
//                })
//                .store(in: &cancellables)
//        }
//    }
