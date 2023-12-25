//
//  MBUsernameSignUpViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit

class MBUsernameSignUpViewController: UIViewController {
    
    private var userData: [String: String]
    private let usernameSignUpView = MBUsernameSignUpView()
    private let loader = MBLoader()

    init(userData: [String: String]) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
        view.addSubview(usernameSignUpView)
        view.addSubview(loader)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome to MaBook"
        view.backgroundColor = .white
        navigationItem.backButtonDisplayMode = .minimal
        usernameSignUpView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameSignUpView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usernameSignUpView.leftAnchor.constraint(equalTo: view.leftAnchor),
            usernameSignUpView.rightAnchor.constraint(equalTo: view.rightAnchor),
            usernameSignUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


extension MBUsernameSignUpViewController: MBUsernameSignUpViewDelegate {
    func mbUsernameSignUpViewDidTapReady(_ usernameSignUpView: MBUsernameSignUpView, firstName: String?, lastName: String?) {
        loader.startLoader()
        guard let firstName = requiredFieldString(from: firstName),
              let lastName = requiredFieldString(from: lastName),
        let email = userData["email"], let password = userData["password"] else {
            presentSingleOptionErrorAlert(
                title: "Whoops", message: "Check your name fields", buttonTitle: "Got it"
            )
            return
        }

        AuthManager.shared.registerWith(
            email: email, password: password,
            name: firstName, lastName: lastName) { [weak self] success in
                DispatchQueue.main.async {
                    self?.loader.stopLoader()
                    if success {
                        self?.presentRequiredController()

                    }
                    else {
                        MBLogger.shared.debugInfo(
                            "end: username sign up vc end with registration response failure"
                        )
                        self?.presentSingleOptionErrorAlert(
                            title: "Damn...",
                            message: "Registration failed, seems we have a problem!",
                            buttonTitle: "Got it"
                        )
                    }
                }
            }
    }
}
