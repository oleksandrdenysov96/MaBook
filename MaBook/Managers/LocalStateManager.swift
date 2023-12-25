//
//  LocalStateManager.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 22.12.2023.
//

import Foundation

public class LocalStateManager {

    public enum Keys: String {
        case token
        case isLoggedIn
        case isOnboarded
        case userData
    }

    static let shared = LocalStateManager()

    private init() {}

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
