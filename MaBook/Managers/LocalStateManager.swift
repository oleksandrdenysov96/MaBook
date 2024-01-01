//
//  LocalStateManager.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 22.12.2023.
//
import UserNotifications
import Foundation

public class LocalStateManager {

    public enum Keys: String {
        case token
        case isLoggedIn
        case isOnboarded
        case userData
        case notificationsPermission
    }

    static let shared = LocalStateManager()

    private init() {}

    public var allBooks: BooksData?
    public var recentlyAdded: BooksData?
    public var mostViewed: BooksData?
    public var categories: [Categories] = []

    public var userName: String? {
        guard let user = loggedUser else {
            return nil
        }
        return "\(user.name.capitalized) \(user.lastName.capitalized)"
    }

    public var loggedUser: User? {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.userData.rawValue),
               let decodedModel = try? JSONDecoder().decode(User.self, from: data) {
                return decodedModel
            }
            return nil
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(
                    encodedData, forKey: Keys.userData.rawValue
                )
            }
        }
    }
}


extension LocalStateManager {

    func requestNotificationPermissionIfNeeded(_ completion: @escaping (Bool) -> Void) {
        let permissionRequested = UserDefaults.standard.bool(forKey: Keys.notificationsPermission.rawValue)

        guard !permissionRequested else {
            return
        }

        UNUserNotificationCenter.current()
            .requestAuthorization() { granted, _ in
            completion(granted)
            UserDefaults.standard.set(
                true, forKey: Keys.notificationsPermission.rawValue
            )
        }
    }
}