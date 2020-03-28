//
//  UIStackView+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/14/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

internal extension UIStackView {
    
    /// This is a helper method to inline assignment of the `axis` and `views` to be added.
    convenience init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = Space.margin8, views: [UIView]? = nil) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        if let subViews = views { self.addArrangedSubviews(subViews) }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
    
    /// Displays the given view by adding it as an addArrangedSubview to the containerView
    /// and animating the alpha from 0 to 1 as buffer for transistioning between the child views.
    ///
    /// - Parameters:
    ///     - view: UIView - Child view to be added.
    func display(view: UIView) {
        // Duration of animation
        let animationDuration = 0.3
        
        // Alpha before updating the containerview.
        alpha = 0.0
        
        // Add the view as the content child view in container view.
        swapArrangedSubviews(with: view)
        
        // Layout the constraints to redraw the view with the content height and set the alpha.
        UIView.animate(withDuration: animationDuration, animations: {
            self.superview?.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: animationDuration) {
                self.alpha = 1.0
            }
        }
    }
}
