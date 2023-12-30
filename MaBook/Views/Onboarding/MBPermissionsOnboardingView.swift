//
//  MBPermissionsOnboardingView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 25.12.2023.
//

import UIKit

protocol MBPermissionsOnboardingViewDelegate: AnyObject {
    func mbPermissionsOnboardingViewDidTapContinue(_ permissionsView: MBPermissionsOnboardingView)
}

class MBPermissionsOnboardingView: UIView {

    public weak var delegate: MBPermissionsOnboardingViewDelegate?

    private let viewDescribtionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.text = MBStrings.mbOnboardingPermissionsLabelText
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let continueButton: MBButton = MBButton(
            title: "Continue",
            titleColor: .white,
            image: nil
    )

    private lazy var trackingSeparator: UIView = separatorLine()

    private lazy var topNotificationsSeparator: UIView = separatorLine()

    private lazy var bottomNotificationsSeparator: UIView = separatorLine()

    private lazy var trackingImageView: UIImageView = imageView(
        with: UIImage(named: "tracking") ?? UIImage()
    )

    private lazy var notificationsImageView: UIImageView = imageView(
        with: UIImage(named: "notification") ?? UIImage()
    )

    private lazy var trackingTitle: UILabel = sectionTitleLabel(with: "Tracking")

    private lazy var trackingDescribtionLabel: UILabel = sectionDescribtionLabel(
        with: MBStrings.mbOnboardingPermissionsTrackingSectionText
    )
    private lazy var notificationsTitle: UILabel = sectionTitleLabel(with: "Notifications")
    private lazy var notificationsDescribtionLabel: UILabel = sectionDescribtionLabel(
        with: MBStrings.mbOnboardingPermissionsNotificationsSectionText)



    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(
            views:
                viewDescribtionLabel,
            trackingSeparator,
            trackingImageView,
            trackingTitle,
            trackingDescribtionLabel,
            topNotificationsSeparator,
            notificationsImageView,
            notificationsTitle,
            notificationsDescribtionLabel,
            bottomNotificationsSeparator,
            continueButton
        )
        setupConstraints()
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }

    @objc private func didTapContinue() {
        delegate?.mbPermissionsOnboardingViewDidTapContinue(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: VIEW REUSE COMPONENTS

    private func separatorLine() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }

    private func imageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.backgroundColor = .clear
        imageView.image = image
        return imageView
    }

    private func sectionTitleLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.text = text
        return label
    }

    private func sectionDescribtionLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = text
        return label
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            viewDescribtionLabel.topAnchor.constraint(equalTo: topAnchor),
            viewDescribtionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewDescribtionLabel.widthAnchor.constraint(equalToConstant: 360),
            viewDescribtionLabel.heightAnchor.constraint(equalToConstant: 150),

            trackingSeparator.topAnchor.constraint(equalTo: viewDescribtionLabel.bottomAnchor, constant: 40),
            trackingSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            trackingSeparator.widthAnchor.constraint(equalToConstant: 360),
            trackingSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),

            trackingImageView.topAnchor.constraint(equalTo: trackingSeparator.bottomAnchor, constant: 20),
            trackingImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            trackingImageView.heightAnchor.constraint(equalToConstant: 20),
            trackingImageView.widthAnchor.constraint(equalToConstant: 25),

            trackingTitle.topAnchor.constraint(equalTo: trackingImageView.bottomAnchor, constant: 20),
            trackingTitle.centerXAnchor.constraint(equalTo: centerXAnchor),

            trackingDescribtionLabel.topAnchor.constraint(equalTo: trackingTitle.bottomAnchor, constant: 15),
            trackingDescribtionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            trackingDescribtionLabel.widthAnchor.constraint(equalToConstant: 360),

            topNotificationsSeparator.topAnchor.constraint(equalTo: trackingDescribtionLabel.bottomAnchor, constant: 25),
            topNotificationsSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            topNotificationsSeparator.widthAnchor.constraint(equalToConstant: 360),
            topNotificationsSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),

            notificationsImageView.topAnchor.constraint(equalTo: topNotificationsSeparator.bottomAnchor, constant: 20),
            notificationsImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notificationsImageView.heightAnchor.constraint(equalToConstant: 25),
            notificationsImageView.widthAnchor.constraint(equalToConstant: 30),

            notificationsTitle.topAnchor.constraint(equalTo: notificationsImageView.bottomAnchor, constant: 20),
            notificationsTitle.centerXAnchor.constraint(equalTo: centerXAnchor),

            notificationsDescribtionLabel.topAnchor.constraint(equalTo: notificationsTitle.bottomAnchor, constant: 15),
            notificationsDescribtionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            notificationsDescribtionLabel.widthAnchor.constraint(equalToConstant: 360),


            bottomNotificationsSeparator.topAnchor.constraint(equalTo: notificationsDescribtionLabel.bottomAnchor, constant: 25),
            bottomNotificationsSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            bottomNotificationsSeparator.widthAnchor.constraint(equalToConstant: 360),
            bottomNotificationsSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),

            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -75),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
