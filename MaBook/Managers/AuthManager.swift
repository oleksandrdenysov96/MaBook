//
//  AuthManager.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation

final class AuthManager {

    static let shared = AuthManager()

    private init() {}

    public var accessToken: String? {
        get {
            UserDefaults.standard.string(
                forKey: LocalStateManager.Keys.token.rawValue
            )
        }
        set(newValue) {
            if let token = newValue {
                UserDefaults.standard.setValue(
                    token, forKey: LocalStateManager.Keys.token.rawValue
                )
            }
        }
    }

    public var isSignedIn: Bool {
        get {
            return accessToken != nil && accessToken != "null"
        }
        set(newValue) {
            if newValue && !isSignedIn {
                UserDefaults.standard.setValue(
                    true,
                    forKey: LocalStateManager.Keys.isLoggedIn.rawValue
                )
            }
        }
    }

    public func registerWith(
        email: String, 
        password: String,
        name: String,
        lastName: String,
        completion: @escaping (Bool) -> Void
    ) {
        let request = MBRequest(endpoint: .auth, httpMethod: .post, pathComponents: ["registration"])
        let body = MBApiCaller.shared.requestBody(
            body: [
                "email": email,
                "password": password,
                "name": name,
                "lastName": lastName
            ]
        )
        MBApiCaller.shared.executeRequest(
            request, body: body, expected: MBAuthResponse.self
        ) { [weak self] result, status in

            switch result {
            case .success(let success):
                self?.accessToken = success.accessToken
                self?.isSignedIn = true
                completion(true)
            case .failure(let failure):
                MBLogger.shared.debugInfo("auth manager: failed to sign in")
                MBLogger.shared.debugInfo("error: \(failure)")
                completion(false)
            }
        }
    }

    public func signInWith(email: String, password: String, 
                           completion: @escaping (Bool) -> Void) {
        let request = MBRequest(endpoint: .auth, httpMethod: .post, pathComponents: ["login"])
        let body = MBApiCaller.shared.requestBody(
            body: ["email": email, "password": password]
        )
        MBApiCaller.shared.executeRequest(
            request, body: body, expected: MBAuthResponse.self
        ) { [weak self] result, status in

            switch result {
            case .success(let success):
                self?.accessToken = success.accessToken
                self?.isSignedIn = true
                completion(true)
            case .failure(let failure):
                MBLogger.shared.debugInfo("auth manager: failed to sign in")
                MBLogger.shared.debugInfo("error: \(failure)")
                completion(false)
            }
        }
    }

    public func getUser(_ completion: @escaping (Bool) -> Void) {
        let request = MBRequest(endpoint: .user)

        MBApiCaller.shared.executeRequest(
            request, accessToken: self.accessToken, expected: MBGetUserResponse.self
        ) { result, status in

            switch result {
            case .success(let response):
                OnboardingManager.shared.isOnboarded = response.data.user.isOnboarding
                LocalStateManager.shared.loggedUser = response.data.user
                completion(true)
            case .failure(let failure):
                MBLogger.shared.debugInfo(
                    "auth manager: failed to get user data"
                )
                MBLogger.shared.debugInfo("error: \(failure)")
                completion(false)
            }
        }
    }
}
