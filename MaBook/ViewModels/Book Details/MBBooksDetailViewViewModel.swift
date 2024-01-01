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

    enum SectionCellType {
        case photo(MBPhotoSectionViewModel)
        case summary(MBSummarySectionViewModel)
        case condition(MBInfoSectionViewModel)
        case pages(MBInfoSectionViewModel)
        case dimensions(MBInfoSectionViewModel)
    }

    private var data: Books

    public var sections = [SectionCellType]()

    private let layout = MBCompositionalLayout()

    init(with data: Books) {
        self.data = data
        retrieveCellsModels()
    }

    public func fetchPrice(_ completion: @escaping (Books) -> Void) {
        let request = MBRequest(endpoint: .books, pathComponents: [String(data.id)])

        MBApiCaller.shared.executeRequest(request, expected: MBBookDetailsResponse.self) { [weak self] result, statusCode in
            switch result {
            case .success(let data):
                self?.data = data.data
                completion(data.data)
            case .failure(let failure):
                MBLogger.shared.debugInfo("failure - \(failure)")
            }
        }
    }

    public func retrieveCellsModels() {
        sections = [
            .photo(.init(imageURL: data.images)),
            .summary(.init(title: data.title, author: data.author, summary: data.description, genre: data.genre)),
            .condition(.init(infoParam: "Condition:", value: data.condition)),
            .pages(.init(infoParam: "Pages:", value: String(data.pages))),
            .dimensions(.init(infoParam: "Dimensions:", value: data.dimensions))
        ]
    }

    public func createLayout(for section: Int) -> NSCollectionLayoutSection {
        switch sections[section] {
        case .photo(_):
            return layout.createBookPhotoDetailsLayout(
                itemWidthDimension: .absolute(310),
                itemHeightDimension: .absolute(310),
                groupWidthDimension: .absolute(310),
                groupHeightDimension: .absolute(310)
            )
        case .summary(_):
            return layout.createBaseLayout(
                itemWidthDimension: .fractionalWidth(1.0),
                itemHeightDimension: .absolute(270),
                groupWidthDimension: .fractionalWidth(1.0),
                groupHeightDimension: .absolute(280)
            )
        case .condition(_), .dimensions(_), .pages(_):
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
