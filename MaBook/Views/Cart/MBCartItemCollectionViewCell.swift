//
//  MBCartItemCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 08.01.2024.
//

import UIKit

protocol MBCartItemCollectionViewCellDelegate: AnyObject {
    func mbCartItemCollectionViewCellDidTapTrash(on cell: MBCartItemCollectionViewCell)
}

class MBCartItemCollectionViewCell: UICollectionViewCell, MBReusableCell {

    public weak var delegate: MBCartItemCollectionViewCellDelegate?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .lightGray
        return imageView
    }()

    private let bookTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textColor = UIColor(red: 0.243, green: 0.286, blue: 0.29, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
        label.textColor = .gray
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18.5)
        label.textColor = UIColor(red: 0.243, green: 0.286, blue: 0.29, alpha: 1)
        return label
    }()

    private let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "trash"), for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            views:
                imageView,
            bookTitle,
            authorLabel,
            priceLabel,
            trashButton
        )
        trashButton.addTarget(
            self,
            action: #selector(didTapTrash),
            for: .touchUpInside
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    public func configure(imageURL: String?, title: String, price: String, author: String) {
        if let imageURL = imageURL {
            imageView.sd_setImage(with: URL(string: imageURL))
        }
        else {
            imageView.image = UIImage(systemName: "photo")
        }
        bookTitle.text = title
        authorLabel.text = "by \(author.capitalized)"
        priceLabel.text = price
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc private func didTapTrash() {
        delegate?.mbCartItemCollectionViewCellDidTapTrash(on: self)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),

            bookTitle.topAnchor.constraint(equalTo: imageView.topAnchor),
            bookTitle.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            bookTitle.widthAnchor.constraint(equalToConstant: 230),
            authorLabel.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 20),
            authorLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),

            priceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 20),
            priceLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),

            trashButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            trashButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            trashButton.widthAnchor.constraint(equalToConstant: 20),
            trashButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
