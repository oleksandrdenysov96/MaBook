//
//  MBMainProfileView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 13.01.2024.
//

import UIKit

class MBMainProfileView: UIView {

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let 

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }

}
