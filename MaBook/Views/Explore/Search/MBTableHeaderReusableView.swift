//
//  MBTableHeaderReusableView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 06.01.2024.
//

import UIKit

protocol MBTableHeaderReusableViewDelegate: AnyObject {
    func mbTableHeaderReusableViewDidTapButton(_ headerView: MBTableHeaderReusableView)
}

class MBTableHeaderReusableView: UIView {

    public weak var delegate: MBTableHeaderReusableViewDelegate?

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18.5)
        label.textColor = UIColor(
            red: 0.243, green: 0.286, blue: 0.29, alpha: 1
        )
        return label
    }()

    private let headerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(title)
        addSubview(headerButton)

        headerButton.addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    @objc private func didTapButton() {
        delegate?.mbTableHeaderReusableViewDidTapButton(self)
    }

    public func configureHeaderTitle(withText text: String) {
        title.text = text
    }

    public func configureHeaderButton(withText text: String, isDestructive: Bool, shouldShow: Bool) {
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.underlineStyle:
                    NSUnderlineStyle.single.rawValue
            ]
        )
        if shouldShow {
            headerButton.isHidden = false
            headerButton.setAttributedTitle(attributedString, for: .normal)
            isDestructive ?
            headerButton.setTitleColor(.red, for: .normal) :
            headerButton.setTitleColor(.black, for: .normal)
        }
        else {
            headerButton.isHidden = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),

            headerButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            headerButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
