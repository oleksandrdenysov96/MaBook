//
//  MBBadgeable.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 10.01.2024.
//

import UIKit
import Foundation

protocol MBBadgeable: AnyObject {

    var badgeView: UIView? { get set }
    var badgeLabel: UILabel? { get set }
    func showBadge(withBlink: Bool)
    func hideBadge()
}

extension MBBadgeable where Self: UIView {

    func showBadge(withBlink: Bool) {
        guard let numberOfItems = LocalStateManager.shared.cartItemsCount,
              numberOfItems != "0" else {
            MBLogger.shared.debugInfo("badgeable: no items in cart for showing the badge")
            return
        }
        if let badgeView = badgeView {
            if !badgeView.isHidden {
                return
            }
        }
        else {
            badgeView = UIView()
        }

        guard let badgeView = badgeView else { return }
        badgeView.backgroundColor = UIColor(red: 0.83, green: 0.33, blue: 0.33, alpha: 1)

        addSubview(badgeView)
        badgeView.translatesAutoresizingMaskIntoConstraints = false

        let size = CGFloat(26)

        if badgeLabel == nil {
            badgeLabel = UILabel()
        }
        guard let safeBadgeLabel = badgeLabel else { return }

        safeBadgeLabel.text = String(numberOfItems)
        safeBadgeLabel.textColor = .white
        safeBadgeLabel.font = .systemFont(ofSize: 15, weight: .bold)
        safeBadgeLabel.translatesAutoresizingMaskIntoConstraints = false

        badgeView.addSubview(safeBadgeLabel)
        safeBadgeLabel.centerXAnchor
            .constraint(equalTo: badgeView.centerXAnchor)
            .isActive = true
        safeBadgeLabel.centerYAnchor
            .constraint(equalTo: badgeView.centerYAnchor)
            .isActive = true

        badgeView.layer.cornerRadius = size / 2

        NSLayoutConstraint.activate([
            badgeView.widthAnchor.constraint(equalToConstant: size),
            badgeView.heightAnchor.constraint(equalToConstant: size),
            badgeView.topAnchor.constraint(equalTo: self.topAnchor, constant: -size / 3.3),
            badgeView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: size / 3.3)
        ])

        if withBlink {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = 1.2
            animation.repeatCount = 1.0
            animation.fromValue = 0
            animation.toValue = 1
            animation.timingFunction = .init(name: .easeOut)
            badgeView.layer.add(animation, forKey: "badgeBlinkAnimation")
        }

    }

    func updateBadgeCounter(withCount count: String) {
        guard let label = badgeLabel else {
            MBLogger.shared.debugInfo("no baadge is setup for update")
            return
        }
        label.text = String(count)
    }

    func hideBadge() {
        badgeView?.layer.removeAnimation(forKey: "badgeBlinkAnimation")
        badgeView?.removeFromSuperview()
        badgeView = nil
        badgeLabel = nil
    }
}
