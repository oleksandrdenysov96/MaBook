//
//  MBBookFilterTextFiledCell.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 03.01.2024.
//

import UIKit

class MBBookFilterTextFiledCell: UITableViewCell, MBReusableCell {

    public var minFieldValueChanged: ((String) -> Void)?
    public var maxFieldValueChanged: ((String) -> Void)?

    public private(set) lazy var minField: UITextField = {
        let field = self.setupTextField()
        return field
    }()

    public private(set) lazy var maxField: UITextField = {
        let field = self.setupTextField()
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubviews(views: minField, maxField)

        minField.addTarget(
            self, action: #selector(minFieldEditingChanged(_:)), for: .editingDidEnd
        )
        maxField.addTarget(
            self, action: #selector(maxFieldEditingChanged(_:)), for: .editingDidEnd
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    @objc private func minFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        minFieldValueChanged?(text)
    }

    @objc private func maxFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        maxFieldValueChanged?(text)
    }

    public func configurePlaceholder() {
        minField.placeholder = "Min"
        maxField.placeholder = "Max"
    }

    private func setupTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.backgroundColor = UIColor(
            red: 0.934, green: 0.945, blue: 0.946, alpha: 1
        )
        textField.layer.cornerRadius = 20

        let leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: 10)
        )
        leftView.backgroundColor = .clear
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }

    private func setupConstraints() {
        let width = (contentView.bounds.width / 2) - 30
        let height = contentView.bounds.height / 1.5
        NSLayoutConstraint.activate([
            minField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            minField.widthAnchor.constraint(equalToConstant: width),
            minField.heightAnchor.constraint(equalToConstant: height),
            minField.centerYAnchor.constraint(equalTo: centerYAnchor),

            maxField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            maxField.widthAnchor.constraint(equalToConstant: width),
            maxField.heightAnchor.constraint(equalToConstant: height),
            maxField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
