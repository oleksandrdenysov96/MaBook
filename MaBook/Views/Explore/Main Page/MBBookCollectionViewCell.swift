//
//  MBBookCollectionViewCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 26.12.2023.
//

import UIKit

enum CellBadgeType {
    case views
    case timestamp
    case none
}

class MBBookCollectionViewCell: UICollectionViewCell, MBReusableCell {

    internal let addToCartButton: MBButton = {
        return MBButton(title: "Add to Cart")
    }()

    internal let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()

    internal let priceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(
            red: 0.93, green: 0.95, blue: 0.95, alpha: 1
        )
        view.layer.opacity = 0.95
        return view
    }()

    internal let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()

    internal let cellBookTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.contentMode = .top
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    internal let genreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(
            red: 0.93, green: 0.95, blue: 0.95, alpha: 1
        )
        view.layer.cornerRadius = 13
        view.layer.opacity = 0.6
        return view
    }()

    internal let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    internal var badgeView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupCommonSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setupCommonSubviews() {
        contentView.addSubviews(
            views: imageView,
            priceView,
            priceLabel,
            cellBookTitle,
            genreView,
            genreLabel
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        priceLabel.text = nil
        cellBookTitle.text = nil
        genreLabel.text = nil
        if let views = badgeView as? MBViewsBadgeView {
            views.imageView.image = nil
            views.label.text = nil
            views.removeFromSuperview()
        }
        else if let timestamp = badgeView as? MBTimestamtBadgeView {
            timestamp.label.text = nil
            timestamp.removeFromSuperview()
        }
    }


    public func configure(with model: Book, withBadge badge: CellBadgeType) {
        switch badge {
        case .views:
            badgeView = MBViewsBadgeView()
            guard let view = badgeView as? MBViewsBadgeView else {
                return
            }
            addSubview(view)
            view.configureViewsBadge(with: String(model.view))
            setupBagdeConstraints(badgeView: view)

        case .timestamp:
            badgeView = MBTimestamtBadgeView()
            guard let view = badgeView as? MBTimestamtBadgeView else {
                return
            }
            addSubview(view)
            view.configureTimestampBadge(with: model.createdAt)
            setupBagdeConstraints(badgeView: view)
            
        case .none:
            break
        }
        priceLabel.text = "\(model.price) P"
        cellBookTitle.text = model.title
        genreLabel.text = model.genre

        guard let bookImage = model.images.first,
              let url = URL(string: bookImage) else {
            MBLogger.shared.debugInfo(
                "book cell: Image for book isn't found"
            )
            imageView.image = UIImage(systemName: "photo")
            imageView.tintColor = .lightGray
            return
        }
        imageView.sd_setImage(with: url)
    }

    
    internal func setupBagdeConstraints<T: UIView>(badgeView: T) {
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: imageView.topAnchor),
            badgeView.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            badgeView.widthAnchor.constraint(equalToConstant: 60),
            badgeView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    internal func setupConstraints() {
        priceView.addSubview(priceLabel)
        genreView.addSubview(genreLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            priceView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            priceView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 18),
            priceLabel.leftAnchor.constraint(equalTo: priceView.leftAnchor, constant: 5),
            priceLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),

            cellBookTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            cellBookTitle.heightAnchor.constraint(equalToConstant: 45),
            cellBookTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            genreView.topAnchor.constraint(equalTo: cellBookTitle.bottomAnchor, constant: 6),
            genreView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            genreView.heightAnchor.constraint(equalToConstant: 25),
            genreView.widthAnchor.constraint(equalToConstant: 75),

            genreLabel.centerXAnchor.constraint(equalTo: genreView.centerXAnchor),
            genreLabel.centerYAnchor.constraint(equalTo: genreView.centerYAnchor)
        ])
    }
}
