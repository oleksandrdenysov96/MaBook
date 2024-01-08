//
//  MBPermissionsOnboardingViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit
import UserNotifications

class MBPermissionsOnboardingViewController: UIViewController {

    private let permissionsView = MBPermissionsOnboardingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(permissionsView)
        permissionsView.delegate = self
        navigationItem.hidesBackButton = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            permissionsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            permissionsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            permissionsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            permissionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MBPermissionsOnboardingViewController: MBPermissionsOnboardingViewDelegate {
    func mbPermissionsOnboardingViewDidTapContinue(_ permissionsView: MBPermissionsOnboardingView) {
        LocalStateManager.shared.requestNotificationPermissionIfNeeded { [weak self] granted in
            if !granted {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(
                        title: "Enable Notifications",
                        message: "To receive important updates, please enable notifications in Settings.",
                        preferredStyle: .alert
                    )

                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alertController.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { _ in
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }))

                    self?.present(alertController, animated: true) {

                    }
                }
            }

            DispatchQueue.main.async {
                let vc = MBTabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
}
