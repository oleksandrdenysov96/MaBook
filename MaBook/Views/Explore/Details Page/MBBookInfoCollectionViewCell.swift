//
//  MBBookInfoCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 01.01.2024.
//

import UIKit

class MBBookInfoCollectionViewCell: UICollectionViewCell, MBReusableCell {

    private let infoParameter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.243, green: 0.286, blue: 0.29, alpha: 1)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        return label
    }()

    private let infoValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.243, green: 0.286, blue: 0.29, alpha: 1)
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            views: infoParameter, infoValue
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with viewModel: MBInfoSectionViewModel) {
        infoParameter.text = viewModel.infoParam
        infoValue.text = viewModel.value
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoParameter.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoParameter.leftAnchor.constraint(equalTo: contentView.leftAnchor),

            infoValue.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoValue.leftAnchor.constraint(equalTo: infoParameter.rightAnchor, constant: 10)
        ])
    }
}
