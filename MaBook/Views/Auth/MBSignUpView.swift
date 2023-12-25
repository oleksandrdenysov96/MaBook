//
//  MBSignUpView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 23.12.2023.
//

import UIKit

protocol MBSignUpViewDelegate: AnyObject {
    func mbSignUpViewDidTapBackToLogin(_ signUpView: MBSignUpView)
    func mbSignUpViewDidTapTerms(_ signUpView: MBSignUpView)
    func mbSignUpViewDidTapPolicy(_ signUpView: MBSignUpView)
    func mbSignUpViewDidTapRegister(_ signUpView: MBSignUpView, email: String?, password: String?)
}

class MBSignUpView: UIView {

    private var isAgreedTerms = false

    public weak var delegate: MBSignUpViewDelegate?

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

    private let termsCheckbox: UIButton = {
        let checkbox = UIButton(type: .system)
        checkbox.setImage(UIImage(
            systemName: "square"
        ), for: .normal)
        checkbox.backgroundColor = .clear
        checkbox.isSelected = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "I agree to the "
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let termsLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terms of Use", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = " & "
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let privacyLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let registerButton: MBButton = {
        let button = MBButton(
            title: "Register",
            titleColor: .white,
            image: nil
        )
        button.alpha = 0.6
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let appleSignInButton: MBButton = {
        return MBButton(.apple)
    }()

    private let facebookSignInButton: MBButton = {
        return MBButton(.facebook)
    }()

    private let googleSignInButton: MBButton = {
        return MBButton(.google)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubviews(
            views: emailTextField, passwordTextField, registerButton,
            separatorView, appleSignInButton, facebookSignInButton,
            googleSignInButton, loginLabel, loginButton
        )
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupConstraints()
        addTargets()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [
            termsCheckbox, termsLabel, termsLinkButton,
            privacyLabel, privacyLinkButton
        ])
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            stackView.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor, constant: -25),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            stackView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),

            registerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            separatorView.topAnchor.constraint(
                equalTo: registerButton.bottomAnchor, constant: 55
            ),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.widthAnchor.constraint(equalToConstant: 360),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),

            appleSignInButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 40),
            appleSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            facebookSignInButton.topAnchor.constraint(equalTo: appleSignInButton.bottomAnchor, constant: 20),
            facebookSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            googleSignInButton.topAnchor.constraint(equalTo: facebookSignInButton.bottomAnchor, constant: 20),
            googleSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            loginLabel.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 35),
            loginLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension MBSignUpView {

    private func addTargets() {
        termsCheckbox.addTarget(self, action: #selector(didSelectCheckBox), for: .touchUpInside)
        termsLinkButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyLinkButton.addTarget(self, action: #selector(didTapPolicy), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    @objc private func didSelectCheckBox() {
        termsLabel.textColor = .black
        termsLinkButton.setTitleColor(.black, for: .normal)
        privacyLabel.textColor = .black
        privacyLinkButton.setTitleColor(.black, for: .normal)

        if isAgreedTerms {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.termsCheckbox.setImage(UIImage(
                    systemName: "square"
                ), for: .normal)
                self?.registerButton.alpha = 0.6
            }, completion: { _ in
                self.isAgreedTerms = false
            })
        }
        else {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.termsCheckbox.setImage(UIImage(
                    systemName: "checkmark.square.fill"
                ), for: .normal)
                self?.registerButton.alpha = 1
            }, completion: { _ in
                self.isAgreedTerms = true
            })
        }

    }

    @objc private func didTapTerms() {
        delegate?.mbSignUpViewDidTapTerms(self)
    }

    @objc private func didTapPolicy() {
        delegate?.mbSignUpViewDidTapPolicy(self)
    }

    @objc private func didTapRegister() {
        if isAgreedTerms {
            delegate?.mbSignUpViewDidTapRegister(
                self, email: emailTextField.text, password: passwordTextField.text
            )
        }
        else {
            termsLabel.textColor = .red
            termsLinkButton.setTitleColor(.red, for: .normal)
            privacyLabel.textColor = .red
            privacyLinkButton.setTitleColor(.red, for: .normal)
        }
    }
    
    @objc private func didTapLogin() {
        delegate?.mbSignUpViewDidTapBackToLogin(self)
    }
}

extension MBSignUpView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapRegister()
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

}
