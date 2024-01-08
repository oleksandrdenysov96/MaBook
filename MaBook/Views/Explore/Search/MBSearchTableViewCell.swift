//
//  MBSearchTableViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 06.01.2024.
//

import UIKit

class MBSearchTableViewCell: UITableViewCell, MBReusableCell {

    private let bookTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let authorTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Italic", size: 14)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(views: bookTitle, authorTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bookTitle.text = nil
        authorTitle.text = nil
    }

    public func configure(title: String, author: String) {
        bookTitle.text = title
        authorTitle.text = author
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bookTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            bookTitle.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 1.5),
            bookTitle.centerYAnchor.constraint(equalTo: centerYAnchor),

            authorTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            authorTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }


}
