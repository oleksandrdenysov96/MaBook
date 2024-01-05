//
//  MBBookListFilterAvailableCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 03.01.2024.
//

import UIKit

class MBBookListFilterAvailableCell: UITableViewCell, MBReusableCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(
            red: 0.243, green: 0.286, blue: 0.29, alpha: 1
        )
        label.font = UIFont(
            name: "HelveticaNeue-Medium", size: 18
        )
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubviews(views: titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    public func configure(titleData: String) {
        titleLabel.text = titleData
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15)
        ])
    }

}
