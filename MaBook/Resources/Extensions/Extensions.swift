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

    func presentMultiOptionAlert(
        title: String = "Are you sure?",
        message: String,
        actionTitle: String,
        buttonTitle: String,
        _ actionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { _ in
            actionHandler()
        }))
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

    func setupDedicatedView(_ view: UIView, topMargin margin: CGFloat = 0) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    func setupLoader(_ loader: MBLoader) {
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
