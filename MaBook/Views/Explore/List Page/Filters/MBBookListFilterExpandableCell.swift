//
//  MBBookListFilterExpandableCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 03.01.2024.
//

import UIKit

class MBBookListFilterExpandableCell: UITableViewCell, MBReusableCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(
            red: 0.243, green: 0.286, blue: 0.29, alpha: 1
        )
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
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
        accessoryView = nil
        accessoryType = .none
        titleLabel.text = nil
    }

    public func configure(
        withType type: MBBookListFiltersViewModel.ExpandableCellType,
        withText text: String
    ) {
        switch type {
        case .sectionCell:
            accessoryView = UIImageView(
                image: UIImage(systemName: "chevron.down")
            )
            accessoryView?.tintColor = .gray
            titleLabel.text = text
            titleLabel.font = UIFont(
                name: "HelveticaNeue-Medium", size: 18
            )
        case .optionCell:
            
            titleLabel.text = text
            titleLabel.font = UIFont(
                name: "HelveticaNeue-Regular", size: 15
            )
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15)
        ])
    }

}
