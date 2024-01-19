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
                title: "\(user.name) \(user.lastName)", id: String(user.id)
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
}
