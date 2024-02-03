//
//  MBCartProvidingViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 09.01.2024.
//

import UIKit

class MBCartProvidingViewController: UIViewController {
    
    var floatingButton: MBFloatingCartButton = {
        let button = MBFloatingCartButton(frame: .zero)
        button.isHidden = false
        button.alpha = 1
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    internal func applyCartView<T: MBCartProvidingView>(fromChild view: T) {
//        view.cartProviderDelegate = self
//    }

    internal func applyCartButtonTarget(_ button: MBFloatingCartButton) {
        button.addTarget(
            self,
            action: #selector(shouldPresentCartController),
            for: .touchUpInside
        )
    }

    @objc internal func shouldPresentCartController() {
        let cartVC = MBCartViewController()
        modalPresentationStyle = .fullScreen
        let navWrapper = UINavigationController(rootViewController: cartVC)
        navWrapper.modalPresentationStyle = .fullScreen
        present(navWrapper, animated: true)
    }
}
