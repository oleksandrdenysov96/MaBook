//
//  MBBookReusableView.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 08.01.2024.
//

import UIKit

class MBCartProvidingView: UIView, MBCartProvideable {

    public weak var cartProviderDelegate: MBCartProvidingViewDelegate?

    var floatingButton: MBFloatingCartButton = {
        let button = MBFloatingCartButton(frame: .zero)
        button.isHidden = false
        button.alpha = 1
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        floatingButton.addTarget(
            self,
            action: #selector(didTapCartButton),
            for: .touchUpInside
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc internal func didTapCartButton() {
        cartProviderDelegate?.mbCartProvidingViewDidTapCartButton()
    }
}
