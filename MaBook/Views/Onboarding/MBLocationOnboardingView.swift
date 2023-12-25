//
//  MBLocationOnboardingView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 24.12.2023.
//

import UIKit

protocol MBLocationOnboardingViewDelegate: AnyObject {
    func mbLocationOnboardingViewDidTapCountry(onboardingView: MBLocationOnboardingView)
    func mbLocationOnboardingViewDidTapLanguage(onboardingView: MBLocationOnboardingView)
    func mbLocationOnboardingViewDidTapReady(onboardingView: MBLocationOnboardingView)
}

class MBLocationOnboardingView: UIView {
    
    public weak var delegate: MBLocationOnboardingViewDelegate?

    private let appLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MaBOOK"
        label.textColor = .black
        label.font = UIFont(name: "RobotoCondensed-Light", size: 45)
        return label
    }()

    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let wantExchangeBooksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I want to exchange books in"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let selectCountryButton: UIButton = {
        let button = MBDropdownButton(title: "Country")
        return button
    }()

    private let selectBookLanguageButton: UIButton = {
        let button = MBDropdownButton(title: "Book Language")
        return button
    }()

    private let readyToGoButton: MBButton = {
        let button = MBButton(
            title: "Ready to Go",
            titleColor: .white,
            image: nil
        )
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        isHidden = true
        alpha = 0
        addSubviews(
            views: appLabel,
            locationImageView,
            wantExchangeBooksLabel,
            selectCountryButton,
            selectBookLanguageButton,
            readyToGoButton
        )
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
        let leftMargins: CGFloat = 25

        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            appLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMargins),

            locationImageView.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 30),
            locationImageView.leftAnchor.constraint(equalTo: appLabel.leftAnchor),
            locationImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -leftMargins),
            locationImageView.heightAnchor.constraint(equalToConstant: 200),

            wantExchangeBooksLabel.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 55),
            wantExchangeBooksLabel.leftAnchor.constraint(equalTo: appLabel.leftAnchor),
            
            selectCountryButton.topAnchor.constraint(equalTo: wantExchangeBooksLabel.bottomAnchor, constant: 35),
            selectCountryButton.leftAnchor.constraint(equalTo: appLabel.leftAnchor),
            selectCountryButton.widthAnchor.constraint(equalTo: locationImageView.widthAnchor),

            selectBookLanguageButton.topAnchor.constraint(equalTo: selectCountryButton.bottomAnchor, constant: 30),
            selectBookLanguageButton.leftAnchor.constraint(equalTo: appLabel.leftAnchor),
            selectBookLanguageButton.widthAnchor.constraint(equalTo: locationImageView.widthAnchor),
            
            readyToGoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70),
            readyToGoButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    public func modifyButtonTitle(countryTitle: String? = nil, languageTitle: String? = nil) {
        if let countryTitle = countryTitle {
            selectCountryButton.setTitle(countryTitle, for: .normal)
        }
        if let languageTitle = languageTitle {
            selectBookLanguageButton.setTitle(languageTitle, for: .normal)
        }
    }

    private func addTargets() {
        selectCountryButton.addTarget(self, action: #selector(didTapSelectCountry), for: .touchUpInside)
        selectBookLanguageButton.addTarget(self, action: #selector(didTapSelectLanguage), for: .touchUpInside)
        readyToGoButton.addTarget(self, action: #selector(didTapReady), for: .touchUpInside)
    }


    @objc private func didTapSelectCountry() {
        delegate?.mbLocationOnboardingViewDidTapCountry(onboardingView: self)
    }

    @objc private func didTapSelectLanguage() {
        delegate?.mbLocationOnboardingViewDidTapLanguage(onboardingView: self)
    }

    @objc private func didTapReady() {
        delegate?.mbLocationOnboardingViewDidTapReady(onboardingView: self)
    }

}
