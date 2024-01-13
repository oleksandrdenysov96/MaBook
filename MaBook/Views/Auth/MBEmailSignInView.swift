//
//  MBEmailSignInView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 23.12.2023.
//

import UIKit

protocol MBEmailSignInViewDelegate: AnyObject {
    func mbEmailSignInViewDidTapLoginButton(
        _ emailSignInView: MBEmailSignInView, email: String?, password: String?
    )
}

class MBEmailSignInView: UIView {

    public weak var delegate: MBEmailSignInViewDelegate?

    private let emailTextField: MBTextField = {
        let field = MBTextField(placeholder: "Enter email")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordTextField: MBTextField = {
        let field = MBTextField(
            placeholder: "Enter password", isSecure: true
        )
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let loginButton: MBButton = {
        let button = MBButton(
            title: "Login",
            titleColor: .white,
            image: nil
        )
        return button
    }()

    private let separatorView: MBSeparator = {
        return MBSeparator()
    }()

    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubviews(
            views: emailTextField,
            passwordTextField,
            separatorView,
            loginButton,
            forgotPasswordButton
        )
        setupConstraints()
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints()  {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -170),

            loginButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: centerXAnchor)

        ])
    }

    @objc private func didTapLogin() {
        delegate?.mbEmailSignInViewDidTapLoginButton(
            self, email: emailTextField.text, password: passwordTextField.text
        )
    }

}
