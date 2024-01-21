//
//  MBProfileViewModel.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 16.01.2024.
//

import Foundation


final class MBProfileViewModel {

    enum Sections: CaseIterable {
        case userInfo
        case activity
        case settings
    }

    enum ProfileItemTitle: String {
        case favorites = "Favorites"
        case exchangedBooks = "Exchanged Books"
        case purchasedBooks = "Purchased Books"
        case locationLanguage = "Location/Language"
        case deliveryAddress = "Location/Delivery Address"
        case notifications = "Notifications"
        case logout = "Logout"
    }

    public var infoItems = [AnyProfileCell]()
    public var activityItems = [AnyProfileCell]()
    public var settingsItems = [AnyProfileCell]()

    public var favorites = [Book]()

    init() {
        setupSectionsStructure()
    }

    private func setupSectionsStructure() {
        guard let user = LocalStateManager.shared.loggedUser else {
            MBLogger.shared.debugInfo(
                "profile vm: unable to retrieve user from local state"
            )
            return
        }
        infoItems = [
            AnyProfileCell(MBUserInfoCellViewModel(
                title: "\(user.name) \(user.lastName)",
                id: String(user.id)
            ))
        ]
        activityItems = [
            AnyProfileCell(MBGenericProfileCellViewModel(
                title: ProfileItemTitle.favorites.rawValue
            )),
            AnyProfileCell(MBGenericProfileCellViewModel(
                title: ProfileItemTitle.exchangedBooks.rawValue
            )),
            AnyProfileCell(MBGenericProfileCellViewModel(
                title: ProfileItemTitle.purchasedBooks.rawValue
            ))
        ]

        settingsItems = [
            AnyProfileCell(MBGenericProfileCellViewModel(
                title: ProfileItemTitle.locationLanguage.rawValue
            )),
            AnyProfileCell(MBGenericProfileCellViewModel(
                title: ProfileItemTitle.deliveryAddress.rawValue
            )),
            AnyProfileCell(MBGenericProfileCellViewModel(
                title: ProfileItemTitle.notifications.rawValue
            )),
            AnyProfileCell(MBGenericProfileCellViewModel(
                title: ProfileItemTitle.logout.rawValue
            )),
        ]
    }

    public func postAvatarData(
        _ data: Data?, _ completion: @escaping (Bool) -> Void
    ) {
        guard let data = data, let user = LocalStateManager
            .shared.loggedUser else {
            return
        }
        let boundary = UUID().uuidString
        let requestCore = MBRequest(
            endpoint: .user,
            httpMethod: .patch,
            pathComponents: [String(user.id)]
        )
        guard var request = MBApiCaller.shared.request(
            from: requestCore, body: nil, accessToken: AuthManager.shared.accessToken
        ) else {
            return
        }
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        var body = Data()
        let rawBody = [
            "--\(boundary)\r\n",
            "Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n",
            "Content-Type: image/jpeg\r\n\r\n"
        ]

        for line in rawBody {
            if let lineData = line.data(using: .utf8) {
                body.append(lineData)
            }
        }
        body.append(data)

        if let closingBoundaryData = "\r\n--\(boundary)--\r\n"
            .data(using: .utf8) {
            body.append(closingBoundaryData)
        }
        request.httpBody = body

        MBApiCaller.shared.performRawRequest(
            urlRequest: request, responseType: MBGetUserResponse.self
        ) { result, statusCode in
            switch result {
            case .success(let success):
                LocalStateManager.shared.loggedUser = success.data.user
                completion(true)
            case .failure(let failure):
                MBLogger.shared.debugInfo("vm: failed to parse response result")
                MBLogger.shared.debugInfo("error - \(failure)")
                completion(false)
            }
        }
    }

    public func logout() {
        let request = MBRequest(endpoint: .auth, pathComponents: ["logout"])

        MBApiCaller.shared.executeRequest(request, expected: String.self) { result, statusCode in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }

    public func fetchFavorites(_ completion: @escaping ([Book]?) -> Void) {
        let request = MBRequest(endpoint: .user, pathComponents: ["favorites"])

        MBApiCaller.shared.executeRequest(
            request, expected: MBRequestedBooksResponse.self
        ) { [weak self] result, statusCode in
            switch result {
            case .success(let success):
                self?.favorites = success.data.books
                completion(success.data.books)
            case .failure(let failure):
                MBLogger.shared.debugInfo(
                    "vm: failed to retrieve favorites books"
                )
                MBLogger.shared.debugInfo("error - \(failure)")
            }
        }
    }
}
