//
//  MBSignInOptionsView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 22.12.2023.
//

import UIKit

protocol MBSignInOptionsViewDelegate: AnyObject {
    func mbSignInOptionsViewDidTapWithEmail(_ signInView: MBSignInOptionsView)
    func mbSignInOptionsViewDidTapSignUp(_ signInView: MBSignInOptionsView)
}

class MBSignInOptionsView: UIView {

    public weak var delegate: MBSignInOptionsViewDelegate?

    private let pleaseLoginView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(
            red: 0.93, green: 0.95, blue: 0.95, alpha: 1
        )
        view.layer.cornerRadius = 24
        return view
    }()

    private let personLogoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let pleaseLoginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.text = "Please Login"
        label.textColor = .black
        return label
    }()

    private let viewDescribtionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "You can use your email or continue with one of your social accounts."
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    private let continueWithEmailButton: MBButton = {
        let button = MBButton(
            title: "Continue with email",
            titleColor: .white,
            image: UIImage(named: "mail")
        )
        return button
    }()

    private let separatorView: MBSeparator = {
        return MBSeparator()
    }()

    private let dontHaveAccLabel: UILabel = {
        let label = UILabel()
        label.text = "Don’t have an account yet?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Create an account", for: .normal)
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
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(
            views:
            pleaseLoginView,
            viewDescribtionLabel,
            continueWithEmailButton,
            separatorView,
            appleSignInButton,
            facebookSignInButton,
            googleSignInButton,
            dontHaveAccLabel,
            createAccountButton
        )
        setupConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let stackView = UIStackView(
            arrangedSubviews: [personLogoView, pleaseLoginLabel]
        )
        pleaseLoginView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 1

        NSLayoutConstraint.activate([
            personLogoView.widthAnchor.constraint(equalToConstant: 60),
            personLogoView.heightAnchor.constraint(equalToConstant: 60),
            stackView.topAnchor.constraint(equalTo: pleaseLoginView.topAnchor, constant: 50),
            stackView.leftAnchor.constraint(equalTo: pleaseLoginView.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: pleaseLoginView.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: pleaseLoginView.bottomAnchor, constant: -50),
        ])

        NSLayoutConstraint.activate([
            pleaseLoginView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            pleaseLoginView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pleaseLoginView.widthAnchor.constraint(equalToConstant: 200),
            pleaseLoginView.heightAnchor.constraint(equalToConstant: 200),

            viewDescribtionLabel.topAnchor.constraint(
                equalTo: pleaseLoginView.bottomAnchor, constant: 20
            ),
            viewDescribtionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewDescribtionLabel.heightAnchor.constraint(equalToConstant: 70),
            viewDescribtionLabel.widthAnchor.constraint(equalToConstant: 350),

            continueWithEmailButton.topAnchor.constraint(
                equalTo: viewDescribtionLabel.bottomAnchor, constant: 40
            ),
            continueWithEmailButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.topAnchor.constraint(
                equalTo: continueWithEmailButton.bottomAnchor, constant: 40
            ),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),

            appleSignInButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 40),
            appleSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            facebookSignInButton.topAnchor.constraint(equalTo: appleSignInButton.bottomAnchor, constant: 20),
            facebookSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            googleSignInButton.topAnchor.constraint(equalTo: facebookSignInButton.bottomAnchor, constant: 20),
            googleSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            dontHaveAccLabel.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 30),
            dontHaveAccLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: dontHaveAccLabel.bottomAnchor, constant: 10),
            createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension MBSignInOptionsView {

    func addTargets() {
        continueWithEmailButton.addTarget(self, action: #selector(didTapEmail), for: .touchUpInside)
        appleSignInButton.addTarget(self, action: #selector(didTapApple), for: .touchUpInside)
        facebookSignInButton.addTarget(self, action: #selector(didTapFacebook), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(didTapGoogle), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }


    @objc private func didTapEmail() {
        delegate?.mbSignInOptionsViewDidTapWithEmail(self)
    }

    @objc private func didTapApple() {

    }

    @objc private func didTapFacebook() {

    }

    @objc private func didTapGoogle() {

    }

    @objc private func didTapCreateAccount() {
        delegate?.mbSignInOptionsViewDidTapSignUp(self)
    }
}
