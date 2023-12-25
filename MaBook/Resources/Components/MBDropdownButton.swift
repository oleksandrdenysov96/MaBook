//
//  MBDropdownButton.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 24.12.2023.
//

import UIKit

class MBDropdownButton: UIButton {

    private let bottomSeparator = UIView()

    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.setupDefaults()
        self.setSize()
        setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
        setupImageView()
    }

    private func setupDefaults() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        contentHorizontalAlignment = .left

        setTitleColor(.lightGray, for: .normal)
        backgroundColor = .clear
    }

    private func setupImageView() {
        buttonImageView.image = UIImage(systemName: "chevron.down")
        buttonImageView.tintColor = .lightGray
        addSubview(buttonImageView)

        NSLayoutConstraint.activate([
            buttonImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            buttonImageView.widthAnchor.constraint(equalToConstant: 23),
            buttonImageView.heightAnchor.constraint(equalToConstant: 20),
            buttonImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupBorder() {
        bottomSeparator.frame = CGRect(
            x: 0, y: bounds.size.height - 1,
            width: bounds.size.width, height: 0.6
        )
        bottomSeparator.backgroundColor = .black
        addSubview(bottomSeparator)
    }

    public func setSize(width: CGFloat = 360, height: CGFloat = 45) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }
}
