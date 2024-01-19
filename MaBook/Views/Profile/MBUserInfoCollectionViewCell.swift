//
//  MBUserInfoCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 13.01.2024.
//

import UIKit
import Combine


class MBUserInfoCollectionViewCell: UICollectionViewCell, MBReusableCell {

    static let identifier = "MBUserInfoCollectionViewCell"

    public private(set) var tapSubject = PassthroughSubject<Void, Never>()
    public let avatarImage = CurrentValueSubject<UIImage?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 19)
        label.textColor = UIColor(
            red: 0.24, green: 0.29, blue: 0.29, alpha: 1
        )
        label.textAlignment = .center
        return label
    }()

    private lazy var uniqueIdLabel: UILabel = {
        return self.idLabel(isTitle: true)
    }()

    private lazy var uniqueIdValue: UILabel = {
        return self.idLabel(isTitle: false)
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            views: avatarImageView,
            usernameLabel,
            uniqueIdLabel,
            uniqueIdValue
        )

        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(didTapAvatar)
        )
        tapGesture.numberOfTapsRequired = 1
        avatarImageView.addGestureRecognizer(tapGesture)


        avatarImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self, let image = image else {
                    self?.avatarImageView.image = UIImage(systemName: "person")
                    return
                }

                self.avatarImageView.image = image
                self.avatarImageView.layer.cornerRadius = self
                    .avatarImageView
                    .frame.width / 2
            }
            .store(in: &cancellables)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapAvatar() {
        print("cell avatar tapped")
        tapSubject.send()
    }

    private func idLabel(isTitle: Bool) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.5)

        label.textColor = isTitle
        ? UIColor(red: 0.52, green: 0.56, blue: 0.57, alpha: 1)
        : .black

        label.textAlignment = .left
        label.text = isTitle
        ? "Unique ID: "
        : nil

        return label
    }

    public func configure(username: String, id: String) {
        usernameLabel.text = username.capitalized
        uniqueIdValue.text = id
    }

    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 85),
            avatarImageView.heightAnchor.constraint(equalToConstant: 85),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor),

            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),

            uniqueIdLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            uniqueIdLabel.rightAnchor.constraint(
                equalTo: contentView.centerXAnchor, constant: 20
            ),

            uniqueIdValue.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            uniqueIdValue.leftAnchor.constraint(equalTo: uniqueIdLabel.rightAnchor, constant: 3)
        ])
    }
}
