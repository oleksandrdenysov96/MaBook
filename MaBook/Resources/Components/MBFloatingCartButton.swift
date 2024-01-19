//
//  MBFloatingCartButton.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 28.12.2023.
//

import UIKit
import Combine

class MBFloatingCartButton: UIButton, MBBadgeable {
    var badgeView: UIView?
    
    var badgeLabel: UILabel?

    var cancelables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setImage(UIImage(named: "cart"), for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        translatesAutoresizingMaskIntoConstraints = false
        initiateBadge()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initiateBadge() {
        showBadge(withBlink: true)

        LocalStateManager.shared.cartItemsCount
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newValue in
                guard let view = self?.badgeView,
                      let label = self?.badgeLabel,
                      newValue != "0"
                else {
                    self?.hideBadge()
                    return
                }
                if view.isHidden {
                    view.isHidden = false
                }
                label.text = newValue
            })
            .store(in: &cancelables)
    }
}
