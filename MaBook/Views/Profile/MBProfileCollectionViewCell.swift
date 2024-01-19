//
//  MBProfileCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 16.01.2024.
//

import UIKit

class MBProfileCollectionViewCell: UICollectionViewCell, MBReusableCell {

    static let identifier = "MBProfileCollectionViewCell"

    public let cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(
            red: 0.24, green: 0.29, blue: 0.29, alpha: 1
        )
        label.font = UIFont(name: "HelveticaNeue", size: 19)
        return label
    }()

    private let accessoryView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubviews(views: cellTitle, accessoryView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public func configure(with text: String, isDestructive: Bool) {
        cellTitle.text = text
        if isDestructive {
            cellTitle.textColor = .systemRed
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            cellTitle.centerYAnchor.constraint(equalTo: centerYAnchor),

            accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            accessoryView.widthAnchor.constraint(equalToConstant: 20),
            accessoryView.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
}
