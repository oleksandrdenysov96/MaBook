//
//  MBSignUpViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit
import SafariServices

class MBSignUpViewController: UIViewController {

    private let signUpView = MBSignUpView()
    private var registerBody: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome to MaBook"
        view.backgroundColor = .white
        view.addSubview(signUpView)
        signUpView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signUpView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            signUpView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signUpView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MBSignUpViewController: MBSignUpViewDelegate {
    func mbSignUpViewDidTapRegister(_ signUpView: MBSignUpView, email: String?, password: String?) {
        guard let email = requiredFieldString(from: email),
              let password = requiredFieldString(from: password) else {
            MBLogger.shared.debugInfo("end: sign up vc end with password/email failure")
            presentSingleOptionErrorAlert(
                title: "Whoops", message: "Please, fill fields correctly", buttonTitle: "Got it"
            )
            return
        }
        self.registerBody["email"] = email
        self.registerBody["password"] = password

        let vc = MBUsernameSignUpViewController(userData: self.registerBody)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func mbSignUpViewDidTapTerms(_ signUpView: MBSignUpView) {
        let vc = SFSafariViewController(url: URL(string: "https://www.instagram.com/o.dnsv")!)
        present(vc, animated: true)
    }
    
    func mbSignUpViewDidTapPolicy(_ signUpView: MBSignUpView) {
        let vc = SFSafariViewController(url: URL(string: "https://www.instagram.com/o.dnsv")!)
        present(vc, animated: true)
    }
    
    func mbSignUpViewDidTapBackToLogin(_ signUpView: MBSignUpView) {
        navigationController?.popToRootViewController(animated: true)
    }
    

}
