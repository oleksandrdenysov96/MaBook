//
//  Extensions.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 22.12.2023.
//

import UIKit
import Foundation


extension UIView {

    func addSubviews(views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIViewController {

    func requiredFieldString(from string: String?) -> String? {
        guard let string = string, !string.trimmingCharacters(in: .whitespaces).isEmpty,
              !string.trimmingCharacters(in: .whitespaces).isEmpty,
              string.count > 5 else {
            return nil
        }
        return string
    }

    func presentSingleOptionErrorAlert(title: String = "Damn...", message: String, buttonTitle: String = "Got it") {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel))

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    func presentRequiredController() {
        AuthManager.shared.getUser { [weak self] success in
            DispatchQueue.main.async {
                if success && OnboardingManager.shared.isOnboarded {
                    let vc = MBTabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
                else {
                    let vc = UINavigationController(
                        rootViewController: MBLocationOnboardingViewController()
                    )
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }
        }
    }
}
