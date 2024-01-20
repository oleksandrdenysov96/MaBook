//
//  MBCategoriesCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import UIKit

class MBCategoriesCollectionViewCell: UICollectionViewCell, MBReusableCell {

    public static let cellIdentifier = "MBCategoriesCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.5, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(
            red: 0.98, green: 0.98, blue: 0.98, alpha: 1
        )
        setupConstraints()
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(image: String, titleText: String) {
        guard let url = URL(string: image) else { return }
        imageView.sd_setImage(with: url)
        title.text = titleText
    }

    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [imageView, title])
        addSubview(stackView)
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            imageView.heightAnchor.constraint(equalToConstant: 25),
//            imageView.widthAnchor.constraint(equalToConstant: 25),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//
//            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
//            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }


}
