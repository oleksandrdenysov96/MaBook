//
//  MBUsernameSignUpView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 24.12.2023.
//

import UIKit

protocol MBUsernameSignUpViewDelegate: AnyObject {
    func mbUsernameSignUpViewDidTapReady(
        _ usernameSignUpView: MBUsernameSignUpView,
        firstName: String?, lastName: String?
    )
}

class MBUsernameSignUpView: UIView {

    public weak var delegate: MBUsernameSignUpViewDelegate?

    private let firstnameTextField: MBTextField = {
        let field = MBTextField(placeholder: "First name")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let lastnameTextField: MBTextField = {
        let field = MBTextField(placeholder: "Last name")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let readyToGoButton: MBButton = {
        let button = MBButton(
            title: "Ready to Go",
            titleColor: .white,
            image: nil
        )
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubviews(
            views: firstnameTextField,
            lastnameTextField,
            separatorView,
            readyToGoButton
        )
        lastnameTextField.delegate = self
        firstnameTextField.delegate = self
        readyToGoButton.addTarget(self, action: #selector(didTapReady), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints()  {
        NSLayoutConstraint.activate([
            firstnameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            firstnameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            lastnameTextField.topAnchor.constraint(equalTo: firstnameTextField.bottomAnchor, constant: 30),
            lastnameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            separatorView.heightAnchor.constraint(equalToConstant: 0.6),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),

            readyToGoButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            readyToGoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    @objc private func didTapReady() {
        delegate?.mbUsernameSignUpViewDidTapReady(
            self,
            firstName: firstnameTextField.text,
            lastName: lastnameTextField.text
        )
    }

}

extension MBUsernameSignUpView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameTextField {
            lastnameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
//            didTapRegister()
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

}

