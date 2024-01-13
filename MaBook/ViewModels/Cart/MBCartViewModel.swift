//
//  MBCartViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 09.01.2024.
//

import Foundation


final class MBCartViewModel {

    public var basketItems = [Book]() {
        didSet {
            var prices = [Double]()
            basketItems.forEach {
                guard let price = Double($0.price) else {
                    return
                }
                prices.append(price)
            }
            if prices.reduce(0, +) != 0 {
                totalPrice = String("\(prices.reduce(0, +))P")
            }
        }
    }


    public var totalPrice: String = "--"

    public func fetchBasket(_ completion: @escaping (Bool) -> Void) {
        let request = MBRequest(endpoint: .user, pathComponents: ["basket"])

        MBApiCaller.shared.executeRequest(
            request, expected: MBRequestedBooksResponse.self
        ) { [weak self] result, statusCode in

            switch result {
            case .success(let response):
                self?.basketItems = response.data.books


                completion(true)

            case .failure(let failure):
                MBLogger.shared.debugInfo("basket vm: failed to retrieve basket data")
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(false)
            }
        }

    }

    public func removeFromBasket(byId id: String, _ completion: @escaping (Bool) -> Void) {
        let request = MBRequest(endpoint: .user, httpMethod: .delete, pathComponents: ["basket", id])

        MBApiCaller.shared.executeRequest(
            request, expected: MBRequestedBooksResponse.self
        ) { [weak self] result, statusCode in

            switch result {
            case .success(let response):
                self?.basketItems = response.data.books


                completion(true)

            case .failure(let failure):
                MBLogger.shared.debugInfo("basket vm: failed to retrieve basket data")
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(false)
            }
        }
    }
}
