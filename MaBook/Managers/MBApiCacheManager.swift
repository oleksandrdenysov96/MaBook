//
//  MBApiCacheManager.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import Foundation

final class MBApiCacheManager {

    private var endpointsCaches: [MBEndpoint: NSCache<NSString, NSData>] = [:]

    init() {
        setupCache()
    }

    public func cacheResponseFor(endpoint: MBEndpoint, url: URL?) -> Data? {
        guard let url = url, let targetCache = endpointsCaches[endpoint] else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }

    public func setCacheFor(endpoint: MBEndpoint, url: URL?, data: Data) {
        guard let url = url, let targetCache = endpointsCaches[endpoint] else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }


    private func setupCache() {
        MBEndpoint.allCases.forEach { endpoint in
            endpointsCaches[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
