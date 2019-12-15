//
//  UIStackView+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/14/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

internal extension UIStackView {
    /// Adds multiple arranged subviews at once by calling `addArrangedSubview` method.
    ///
    /// - Parameters:
    ///   - views: An array of arranged views to add.
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }

    /// Resets stack view by removing all arranged subviews from `self`.
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    /// Swaps currently visible arranged subviews with a new one.
    ///
    /// - Parameters:
    ///   - view: Arranged view to add as a subview.
    func swapArrangedSubviews(with view: UIView) {
        removeArrangedSubviews()
        addArrangedSubview(view)
    }
}
