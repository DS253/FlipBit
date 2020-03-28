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
            line.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(Space.singlePixel)
            }
            
        case .bottomEdge:
            line.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
                make.height.equalTo(Space.singlePixel)
            }
            
        case .leftEdge:
            line.snp.makeConstraints { make in
                make.top.bottom.leading.equalToSuperview()
                make.width.equalTo(Space.singlePixel)
            }
            
        case .rightEdge:
            line.snp.makeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.width.equalTo(Space.singlePixel)
            }
        }
    }
    
    /// Sets the frame's center to the UIScreen's center.
    internal func setToScreenCenter() {
        center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }
    
    /// Adjusts the width and height of the frame by percentage in relation to the UIScreen bounds.
    ///
    /// - Parameters:
    ///   - width: The percentage of the screen's width.
    ///   - height: The percentage of the screen's height.
    internal func setFrameLengthByPercentage(width: CGFloat, height: CGFloat) {
        let width = UIScreen.main.bounds.width * width
        let height = UIScreen.main.bounds.height * height
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
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
    
    /// Sets the view's layer to the Bybit theme.
    func setBybitTheme() {
        layer.cornerRadius = 14
        layer.borderColor = UIColor.flatNavyBlue.cgColor
        layer.borderWidth = 1.0
        layer.shadowColor = UIColor.flatNavyBlue.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -1, height: 6)
        layer.masksToBounds = false
    }
    
    /// Helper method to simplify the process of adding a `CALayer` as a sublayer.
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
    
    /// Adds multiple subviews at once by calling `addSubview` method.
    ///
    /// - Parameters:
    ///   - views: An array of views to add.
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    /// Will animate subviews visibility in sequence.
    ///
    /// - Parameters:
    ///   - subviews: An array of subviews to animate.
    static func animateViewAlphaSequentually(_ subviews: [UIView]) {
        for (index, aView) in subviews.enumerated() {
            UIView.animate(
                withDuration: Double(subviews.count) * 0.2,
                delay: Double(index) * 0.1,
                options: .curveEaseInOut,
                animations: {
                    aView.alpha = 1.0
                    
            }, completion: nil)
        }
    }
}
