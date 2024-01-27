//
//  MBCartProvidingViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 09.01.2024.
//

import UIKit

class MBCartProvidingViewController: UIViewController, MBCartProvidingViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    internal func applyCartView<T: MBCartProvidingView>(fromChild view: T) {
        view.cartProviderDelegate = self
    }

    public func mbCartProvidingViewDidTapCartButton() {
        let cartVC = MBCartViewController()
        modalPresentationStyle = .fullScreen
        let navWrapper = UINavigationController(rootViewController: cartVC)
        navWrapper.modalPresentationStyle = .fullScreen
        present(navWrapper, animated: true)
    }
}
