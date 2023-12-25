//
//  MBRequest.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation

final class MBRequest {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    struct Constants {
        static let baseUrl = "https://p01--books--qqfgrnqblfk9.code.run/api"
    }

    public let endpoint: MBEndpoint
    public let httpMethod: String
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]

    private var urlString: String {
        var url = "\(Constants.baseUrl)/\(endpoint.rawValue)"

        if !pathComponents.isEmpty {
            pathComponents.forEach { component in
                url += "/\(component)"
            }
        }

        if !queryParameters.isEmpty {
            let argsString = queryParameters.compactMap { param in
                guard let value = param.value else { return nil }
                return "\(param.name)=\(value)"
            }.joined(separator: "&")

            url += "?\(argsString)"
        }
        return url
    }

    public var url: URL? {
        return URL(string: self.urlString)
    }


    init(endpoint: MBEndpoint, httpMethod: HttpMethod = .get, pathComponents: [String] = [],
         queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod.rawValue
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }

    // MARK: Core modeling of endpoint with path components & query params
    convenience init?(url: URL, httpMethod: HttpMethod = .get) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }

        /// Setting an endpoints
        let trimmed = string.replacingOccurrences(of: "\(Constants.baseUrl)/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []

                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }

                if let wtEndpoint = MBEndpoint(rawValue: endpointString) {
                    self.init(endpoint: wtEndpoint, httpMethod: httpMethod, pathComponents: pathComponents)
                    return
                }
            }
        }


        /// Setting an query params
        else if trimmed.contains("?") {
            /// Cutting off query params
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]

                /// Receiving an array of each separated pair of key&value ([name=value, name=value...])
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else {
                        return nil
                    }
                    /// Receiving an array of each key/value separated ([name, value, name, value...])
                    let parts = $0.components(separatedBy: "=")
                    /// And creating an URLQueryItem from each pair!
                    return URLQueryItem(name: parts.first!, value: parts.last!)
                }

                /// So here we already have a query params
                if let wtEndpoint = MBEndpoint(rawValue: endpointString) {
                    self.init(endpoint: wtEndpoint, httpMethod: httpMethod, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}
