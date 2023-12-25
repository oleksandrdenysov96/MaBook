//
//  MBLoader.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 24.12.2023.
//

import UIKit

class MBLoader: UIActivityIndicatorView {

    init() {
        super.init(frame: .zero)
        style = .large
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .label
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 10
        hidesWhenStopped = true
        alpha = 0
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 100),
            widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startLoader() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.alpha = 1
            self?.startAnimating()
        }
    }

    public func stopLoader() {
        stopAnimating()
        alpha = 0
    }
}
