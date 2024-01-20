//
//  MBApiCaller.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation
import Combine

final class MBApiCaller {

    enum MBError: Error {
        case failedToCreateRequest
        case failedToGetData
    }

    private let cacheManager = MBApiCacheManager()

    static let shared = MBApiCaller()

    private init() {}

    public func requestBody(body: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            return jsonData
        } catch {
            MBLogger.shared.debugInfo(
                "api caller failed to form request body: \(error)"
            )
            return nil
        }
    }

    public func request(from mbRequest: MBRequest, body: Data?, accessToken: String? = nil) -> URLRequest? {
        guard let url = mbRequest.url else {
            MBLogger.shared.debugInfo("mbrequest: no url inside")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = mbRequest.httpMethod

        if let body = body {
            request.httpBody = body
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let accessToken = accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    public func executeRequest<T: Codable>(
        _ request: MBRequest,
        body: Data? = nil,
        accessToken: String? = AuthManager.shared.accessToken,
        expected responseType: T.Type,
        shouldCache: Bool = false,
        completion: @escaping (Result<T, Error>, Int?) -> Void
    ) {
        if let cachedData = cacheManager.cacheResponseFor(
            endpoint: request.endpoint,
            url: request.url
        ), shouldCache {
            do {
                MBLogger.shared.debugInfo("api caller: reading from cache")
                MBLogger.shared.debugInfo("request - \(String(describing: request.url))")
                let result = try JSONDecoder().decode(responseType.self, from: cachedData)
                completion(.success(result), nil)
            }
            catch {
                completion(.failure(error), nil)
            }
            return
        }

        guard let urlRequest = self.request(
            from: request, body: body, accessToken: accessToken
        ) else {
            MBLogger.shared.debugInfo("api caller: failed to create request")
            completion(.failure(MBError.failedToCreateRequest), nil)
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            let statusCode = response.statusCode

            guard let data = data, error == nil else{
                completion(.failure(error ?? MBError.failedToGetData), nil)
                return
            }

            // Decode response
            do {
                MBLogger.shared.debugInfo(
                    "Decoding response...\nSource - *** \(String(describing: urlRequest.url!)) ***"
                )
                MBLogger.shared.debugInfo(String(data: data, encoding: .utf8) ?? "unable to read")

                let result = try JSONDecoder().decode(responseType.self, from: data)

                if shouldCache {
                    MBLogger.shared.debugInfo("api caller: setting cache")
                    self?.cacheManager.setCacheFor(
                        endpoint: request.endpoint,
                        url: request.url,
                        data: data
                    )
                }
                completion(.success(result), statusCode)
            }
            catch {
                MBLogger.shared.debugInfo("Failed to decode response")
                MBLogger.shared.debugInfo(
                    "Describtion - \(String(describing: error))\nStatus code - \(statusCode)"
                )
                completion(.failure(error), statusCode)
            }
        }
        task.resume()
    }

    public func performRawRequest<T: Codable>(
        urlRequest: URLRequest,
        responseType: T.Type,
        shouldCache: Bool = false,
        _ completion: @escaping (Result<T, Error>, Int?
        ) -> Void) {

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            let statusCode = response.statusCode

            guard let data = data, error == nil else{
                completion(.failure(error ?? MBError.failedToGetData), nil)
                return
            }

            // Decode response
            do {
                MBLogger.shared.debugInfo(
                    "Decoding response...\nSource - *** \(String(describing: urlRequest.url!)) ***"
                )
                MBLogger.shared.debugInfo(String(data: data, encoding: .utf8) ?? "unable to read")

                let result = try JSONDecoder().decode(responseType.self, from: data)
                completion(.success(result), statusCode)
            }
            catch {
                MBLogger.shared.debugInfo("Failed to decode response")
                MBLogger.shared.debugInfo(
                    "Describtion - \(String(describing: error))\nStatus code - \(statusCode)"
                )
                completion(.failure(error), statusCode)
            }
        }
        task.resume()
    }
}



// MARK: COMBINE REALISATION

extension MBApiCaller {

    public func exectuteCMBRequest<T: Codable>(
        _ request: MBRequest,
        body: Data? = nil,
        accessToken: String? = AuthManager.shared.accessToken,
        expected responseType: T.Type,
        shouldCache: Bool = false
    ) -> (Future<T, Error>) {

        return Future { promise in
            guard let urlRequest = self.request(
                from: request, body: body, accessToken: accessToken
            ) else {
                MBLogger.shared.debugInfo("api caller: failed to create request")
                promise(.failure(Self.MBError.failedToCreateRequest))
                return
            }
            URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                let statusCode = response.statusCode

                guard let data = data, error == nil else {
                    promise(.failure(Self.MBError.failedToGetData))
                    return
                }

                // Decode response
                do {
                    MBLogger.shared.debugInfo(
                        "Decoding response...\nSource - *** \(String(describing: urlRequest.url!)) ***"
                    )
                    MBLogger.shared.debugInfo(String(data: data, encoding: .utf8) ?? "unable to read")

                    let result = try JSONDecoder().decode(responseType.self, from: data)

                    if shouldCache {
                        MBLogger.shared.debugInfo("api caller: setting cache")
                        self?.cacheManager.setCacheFor(
                            endpoint: request.endpoint,
                            url: request.url,
                            data: data
                        )
                    }
                    promise(.success(result))
                }
                catch {
                    MBLogger.shared.debugInfo("Failed to decode response")
                    MBLogger.shared.debugInfo(
                        "Describtion - \(String(describing: error))\nStatus code - \(statusCode)"
                    )
                    promise(.failure(error))
                }
            }.resume()
        }
    }
}
