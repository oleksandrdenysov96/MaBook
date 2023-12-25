//
//  MBEmailSignInViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit

class MBEmailSignInViewController: UIViewController {

    private let emailSignInView = MBEmailSignInView()
    private let loader = MBLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome to MaBook"
        view.backgroundColor = .white
        view.addSubview(emailSignInView)
        view.addSubview(loader)
        navigationItem.backButtonDisplayMode = .minimal

        emailSignInView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailSignInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emailSignInView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emailSignInView.rightAnchor.constraint(equalTo: view.rightAnchor),
            emailSignInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension MBEmailSignInViewController: MBEmailSignInViewDelegate {
    func mbEmailSignInViewDidTapLoginButton(
        _ emailSignInView: MBEmailSignInView, email: String?, password: String?
    ) {
        loader.startLoader()

        guard let email = requiredFieldString(from: email),
              let password = requiredFieldString(from: password) else {
            loader.stopLoader()
            MBLogger.shared.debugInfo("end: email sign in vc ended with wrong fields")

            self.presentSingleOptionErrorAlert(
                title: "Check your credentials",
                message: "Please, double check your creds",
                buttonTitle: "Got it"
            )
            return
        }

        AuthManager.shared.signInWith(email: email, password: password) { [weak self] success in
            DispatchQueue.main.async {
                self?.loader.stopLoader()
                if success {
                    self?.presentRequiredController()
                }
                else {
                    MBLogger.shared.debugInfo(
                        "end: email sign in vc ended with sign in request failure"
                    )
                    self?.presentSingleOptionErrorAlert(
                        title: "Damn...",
                        message: "Sign in failed, seems we have a problem!",
                        buttonTitle: "Got it"
                    )
                }
            }
        }
    }
}
