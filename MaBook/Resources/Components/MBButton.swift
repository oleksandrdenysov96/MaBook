//
//  MBButton.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 22.12.2023.
//

import UIKit

enum SSOOptions {
    case apple
    case facebook
    case google
}

class MBButton: UIButton {

    private let image: UIImage?

    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(
        title: String, 
        buttonColor: UIColor = UIColor(
        red: 0.243, green: 0.286, blue: 0.29, alpha: 1
        ),
        titleColor: UIColor,
        withBorder: Bool = false, image: UIImage?
    ) {
        self.image = image
        super.init(frame: .zero)
        self.setupDefaults()
        self.setSize()
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = buttonColor

        if withBorder {
            layer.borderColor = UIColor(
                red: 0.694, green: 0.747, blue: 0.75, alpha: 1
            ).cgColor
            layer.borderWidth = 1
        }
        setupImageView()
    }

    convenience init(_ option: SSOOptions) {
        var imageName: String!
        var title: String!

        switch option {
        case .apple:
            title = "Sign In with Apple"
            imageName = "apple"
        case .facebook:
            title = "Sign In with Facebook"
            imageName = "facebook"
        case .google:
            title = "Sign In with Google"
            imageName = "google"
        }
        self.init(
            title: title,
            buttonColor: .clear,
            titleColor: .black,
            withBorder: true,
            image: UIImage(named: imageName)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDefaults() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel?.textAlignment = .center
    }

    private func setupImageView() {
        if let image = image {
            buttonImageView.image = image
            addSubview(buttonImageView)

            NSLayoutConstraint.activate([
                buttonImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                buttonImageView.widthAnchor.constraint(equalToConstant: 25),
                buttonImageView.heightAnchor.constraint(equalToConstant: 25),
                buttonImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    public func setSize(width: CGFloat = 360, height: CGFloat = 45) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }

}
