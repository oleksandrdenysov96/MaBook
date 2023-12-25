//
//  MBTextField.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 23.12.2023.
//

import UIKit

class MBTextField: UITextField {

    private let bottomSeparator = UIView()

    init(placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        isSecureTextEntry = isSecure
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        textColor = .black
        autocapitalizationType = .none
        autocorrectionType = .no

        let attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont(name: "Circe-Regular", size: 18)
                ?? UIFont.systemFont(ofSize: 18)
            ]
        )
        self.attributedPlaceholder = attributedPlaceholder
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    private func setup() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 360),
            heightAnchor.constraint(equalToConstant: 55)
        ])
        bottomSeparator.frame = CGRect(
            x: 0, y: bounds.size.height - 1,
            width: bounds.size.width, height: 1
        )
        bottomSeparator.backgroundColor = .black

        self.borderStyle = .none
        addSubview(bottomSeparator)
    }
}
