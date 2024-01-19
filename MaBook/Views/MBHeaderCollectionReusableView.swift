//
//  MBHeaderCollectionReusableView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 18.01.2024.
//

import UIKit

class MBHeaderCollectionReusableView: UICollectionReusableView {

    internal class var identifier: String {
        return "BaseHeaderID"
    }

    internal let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(
            red: 0.243, green: 0.286, blue: 0.29, alpha: 1
        )
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubviews(views: title)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureHeader(with text: String) {
        title.text = text
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 15),
        ])
    }
}
