//
//  MBExploreSectionCollectionReusableView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 27.12.2023.
//

import UIKit

protocol MBExploreSectionCollectionReusableViewDelegate: AnyObject {
    func mbExploreSectionCollectionReusableViewDidTapSeeAll(
        _ reusableView: MBExploreSectionCollectionReusableView
    )
}

class MBExploreSectionCollectionReusableView: UICollectionReusableView {

    static let identifier = "MBExploreSectionCollectionReusableView"
    public weak var delegate: MBExploreSectionCollectionReusableViewDelegate?

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)

        let attributedString = NSAttributedString(
            string: "See all",
            attributes: [
                NSAttributedString.Key.underlineStyle:
                    NSUnderlineStyle.single.rawValue
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubviews(views: title, seeAllButton)
        setupConstraints()
        seeAllButton.addTarget(
            self, action: #selector(didTapSeeAll),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureHeader(with text: String) {
        title.text = text
    }

    @objc private func didTapSeeAll() {
        delegate?.mbExploreSectionCollectionReusableViewDidTapSeeAll(self)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            title.topAnchor.constraint(equalTo: topAnchor),

            seeAllButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            seeAllButton.topAnchor.constraint(equalTo: topAnchor),
            seeAllButton.widthAnchor.constraint(equalToConstant: 60),
            seeAllButton.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
