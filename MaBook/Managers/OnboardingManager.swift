//
//  OnboardingManager.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 22.12.2023.
//

import Foundation


final class OnboardingManager {

    static let shared = OnboardingManager()

    private init() {}

    // TODO: Set to true via isOnboarded flag from parsed User model
    public var isOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(
                forKey: LocalStateManager.Keys.isOnboarded.rawValue
                )
        }
        set {
            if newValue && !isOnboarded {
                UserDefaults.standard.setValue(
                    true,
                    forKey: LocalStateManager.Keys.isOnboarded.rawValue
                )
            }
        }
    }

    public func getLocations(_ completion: 
                             @escaping (Result<MBOnboardingResponse, Error>) -> Void) {
        let request = MBRequest(endpoint: .user, pathComponents: ["onboarding"])

        MBApiCaller.shared.executeRequest(
            request, expected: MBOnboardingResponse.self
        ) { result, statusCode in

            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let failure):
                MBLogger.shared.debugInfo("onboarding manager failed with get locations")
                completion(.failure(failure))
            }
        }
    }

    public func completeOnboardingWith(country: String, language: String, _ completion: @escaping (Bool) -> Void) {
        let request = MBRequest(
            endpoint: .user, httpMethod: .post, pathComponents: ["onboarding"]
        )
        let body = MBApiCaller.shared.requestBody(
            body: [
                "language": language,
                "location": country
            ]
        )
        MBApiCaller.shared.executeRequest(
            request, body: body, expected: Dictionary<String, Int>.self
        ) { result, statusCode in
            switch result {
            case .success(_):
                guard let statusCode = statusCode,
                      statusCode == 201 else {
                    return
                }
                completion(true)
            case .failure(let err):
                MBLogger.shared.debugInfo(
                    "onboarding manager: failure on post onboarding"
                )
                MBLogger.shared.debugInfo("error - \(err)")
                completion(false)
            }
        }
    }
}
