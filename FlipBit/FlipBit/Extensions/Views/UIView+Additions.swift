//
//  UIView+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UIView {
    /// Representation of line position for adding a line to any view.
    /// This type is used to provide strict logic around where a line can be added to a `UIView`.
    /// `LinePosition` is used with the `addLine(_ posisiton:)`
    /// method used primarily to add a divider line to any `UIView`.
    internal enum LinePosition {
        /// Represents the leading(left) edge of a `UIView`.
        case leftEdge

        /// Represents the trailing(right) edge of a `UIView`.
        case rightEdge

        /// Represents the top edge of a `UIView`.
        case topEdge

        /// Represents the bottom edge of a `UIView`.
        case bottomEdge
    }

    // MARK: - Internal Methods

    /// Adds a line to a specific position of this instance using Auto Layout.
    /// This is primary used when adding a divider line between this
    /// view and another view.
    ///
    /// - Parameters:
    ///   - posisiton: The position/location of the line to add.
    internal func addLine(_ posisiton: LinePosition) {
        let line = BaseView()
        line.backgroundColor = .gray
        addSubview(line)

        switch posisiton {
        case .topEdge:
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: topAnchor),
                line.leadingAnchor.constraint(equalTo: leadingAnchor),
                line.trailingAnchor.constraint(equalTo: trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: Dimensions.singlePixel)
            ])

        case .bottomEdge:
            NSLayoutConstraint.activate([
                line.bottomAnchor.constraint(equalTo: bottomAnchor),
                line.leadingAnchor.constraint(equalTo: leadingAnchor),
                line.trailingAnchor.constraint(equalTo: trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: Dimensions.singlePixel)
            ])

        case .leftEdge:
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: topAnchor),
                line.bottomAnchor.constraint(equalTo: bottomAnchor),
                line.leadingAnchor.constraint(equalTo: leadingAnchor),
                line.widthAnchor.constraint(equalToConstant: Dimensions.singlePixel)
            ])

        case .rightEdge:
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: topAnchor),
                line.bottomAnchor.constraint(equalTo: bottomAnchor),
                line.trailingAnchor.constraint(equalTo: trailingAnchor),
                line.widthAnchor.constraint(equalToConstant: Dimensions.singlePixel)
            ])
        }
    }

    // MARK: - Animation Methods

    /// "Shimmer" a view's transparency to indicate a loading state.
    func animateTransparency() {

        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [UIColor.white.cgColor,
                                UIColor.white.withAlphaComponent(0.5).cgColor,
                                UIColor.white.cgColor]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        layer.mask = gradientLayer
        gradientLayer.frame.size = CGSize(width: frame.width * 4, height: frame.height)

        let animation = CABasicAnimation(keyPath: "position.x")

        animation.fromValue = bounds.width - gradientLayer.bounds.width / 2
        animation.toValue = gradientLayer.bounds.width / 2

        animation.duration = 1.5
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "animateTransparency")
    }

    func removeAnimations() {
        layer.removeAllAnimations()
        layer.mask = nil
    }

    // MARK: - CALayer Methods

    /// Helper method to simplify the process of adding a `CALayer` as a sublayer
    /// to a given `UIView` instance.
    ///
    /// - Parameters:
    ///   - layer: The `CALayer` to add as a sublayer to the underlying `layer` property.
    internal func addSublayer(_ layer: CALayer) {
        self.layer.addSublayer(layer)
    }

    func addDropShadow(color: UIColor, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 80
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    /// Helper method to simplify the process of adding a subview with constraints to center the
    /// subview in the parent.
    ///
    /// - Parameters:
    ///   - view: The `View` to add as a subview.
    ///   - constant: The space separating the subview from the parent.
    func addSubview(view: UIView, constant: CGFloat) {
        addSubview(view)
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant).isActive = true
    }
}
