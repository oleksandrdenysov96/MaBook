//
//  MBTabBarViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit

class MBTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.isOpaque = false
        MBLogger.shared.debugInfo("sid created")
        let exploreVC = MBExploreViewController()
        let exchangeBookVC = MBExchangeBookViewController()
        let myPageVC = MBMyPageViewController()

        exploreVC.title = "MaBOOK"


        let exploreNavVC = UINavigationController(rootViewController: exploreVC)
        let exchangeBookNavVC = UINavigationController(rootViewController: exchangeBookVC)
        let myPageNavVC = UINavigationController(rootViewController: myPageVC)

        for controller in [exploreNavVC, exchangeBookNavVC, myPageNavVC] {
            controller.navigationBar.tintColor = .label
        }

        exploreNavVC.tabBarItem = UITabBarItem(
            title: "EXPLORE", image: UIImage(systemName: "book"), tag: 1
        )
        addCustomButton()
        exchangeBookNavVC.tabBarItem = UITabBarItem(
            title: "EXCHANGE BOOK", image: nil, tag: 2
        )
        myPageNavVC.tabBarItem = UITabBarItem(
            title: "MY PAGE", image: UIImage(systemName: "person"), tag: 3
        )

        self.setViewControllers(
            [exploreNavVC, exchangeBookNavVC, myPageNavVC],
            animated: false
        )
    }

    private func addCustomButton() {
        let view = UIView()
        view.backgroundColor = .systemCyan
        view.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(view)

        let imageView = UIImageView(image: UIImage(named: "add"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 45),
            view.widthAnchor.constraint(equalToConstant: 45),
            view.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 5),
            view.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.layer.cornerRadius = 45 / 2
    }
}
