//
//  MBBookSummaryCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 31.12.2023.
//

import UIKit

class MBBookSummaryCollectionViewCell: UICollectionViewCell, MBReusableCell {

    private let genreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(
            red: 0.93, green: 0.95, blue: 0.95, alpha: 1
        )
        view.layer.cornerRadius = 13
        view.layer.opacity = 0.6
        return view
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18.5)
        label.textColor = UIColor(red: 0.243, green: 0.286, blue: 0.29, alpha: 1)
        return label
    }()

    private let authorName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.textColor = .gray
        return label
    }()

    private let bookSummary: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 17.5)
        label.textColor = UIColor(red: 0.243, green: 0.286, blue: 0.29, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            views: genreView, genreLabel,
            title, authorName, bookSummary
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

    public func configure(with viewModel: Book) {
        genreLabel.text = viewModel.genre
        title.text = viewModel.title
        authorName.text = viewModel.author
        bookSummary.text = viewModel.description
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            genreView.topAnchor.constraint(equalTo: contentView.topAnchor),
            genreView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            genreView.widthAnchor.constraint(equalToConstant: 65),
            genreView.heightAnchor.constraint(equalToConstant: 25),

            genreLabel.centerXAnchor.constraint(equalTo: genreView.centerXAnchor),
            genreLabel.centerYAnchor.constraint(equalTo: genreView.centerYAnchor),
            genreLabel.heightAnchor.constraint(equalToConstant: 30),
            genreLabel.widthAnchor.constraint(equalToConstant: 120),

            title.topAnchor.constraint(equalTo: genreView.bottomAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            title.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 2),
            title.heightAnchor.constraint(equalToConstant: 25),

            authorName.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15),
            authorName.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            authorName.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 2.5),
            authorName.heightAnchor.constraint(equalToConstant: 20),

            bookSummary.topAnchor.constraint(equalTo: authorName.bottomAnchor, constant: 25),
            bookSummary.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bookSummary.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -35),
            bookSummary.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
