//
//  MBSignInViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit

class MBSignInOptionsViewController: UIViewController {

    private let signInView = MBSignInOptionsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?
            .navigationBar
            .topItem?
            .backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .gray
        view.backgroundColor = .white
        view.addSubview(signInView)
        title = "Login to Continue"
        signInView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signInView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signInView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MBSignInOptionsViewController: MBSignInOptionsViewDelegate {
    func mbSignInOptionsViewDidTapWithEmail(_ signInView: MBSignInOptionsView) {
        let vc = MBEmailSignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func mbSignInOptionsViewDidTapSignUp(_ signInView: MBSignInOptionsView) {
        let vc = MBSignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}

