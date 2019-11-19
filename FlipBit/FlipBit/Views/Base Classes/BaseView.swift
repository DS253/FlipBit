//
//  BaseView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

/// Provides all basic functionality of `UIView` with the
/// addition of some basic shared functionality that should be
/// adopted by all `UIView` subclasses.
///
/// - Note:
///   Overrides the following methods:
///   - `awakeFromNib()`
///
///   Conforms to the following Protocols:
///   - `Setup`
///
///   The `Setup` methods are called in the following order:
///   - `setup()`
///   - `setupSubviews()`
///   - `setupConstraints()`
///
///   For more information, see **Setup.swift** implementation.
open class BaseView: UIView, ViewSetup {
    /// Creates a `BaseView` instance given the provided parameter(s).
    ///
    /// Use this initializer when you intend to create an instance of a view
    /// in code where the frame will be set by its superview using Auto Layout.
    ///
    /// Calls to each `setup` methods in this order. Each of these methods
    /// are optional to implement depending on developers needs.
    public init() {
        super.init(frame: .zero)
        self.setup()
        self.setupSubviews()
        self.setupConstraints()
    }

    /// Creates a `BaseView` instance given the provided parameter(s).
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Allows for isolated setup of anything relating to `UIView`.
    /// This is a great place to do any setup of model data or layout.
    ///
    /// - Note:
    ///   Called in `init()` immediately following the call to `super.init(frame:)`
    ///   - `setupConstraints()`
    ///
    ///   Default implementation sets the following properties:
    ///   - `backgroundColor = .clear`
    ///   - `translatesAutoresizingMaskIntoConstraints = false`
    ///
    ///   For more information, see **Setup.swift** implementation.
    open func setup() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Allows for isolated setup of **subviews** relating to this `UIView`.
    /// This can include layout, configuration, customization, etc.
    ///
    /// - Note:
    ///   Called in `init()` immediately following the call to `super.init(frame:)`
    ///
    ///   For more information, see **Setup.swift** implementation.
    open func setupSubviews() { }

    /// Allows for isolated setup of **constraints** relating to this `UIView`.
    /// This should only include configuration of any `NSLayoutConstraint` relating
    /// to this specific `UIView` or it's subviews.
    ///
    /// - Note:
    ///   Called in `init()` immediately following the call to `super.init(frame:)`
    ///
    ///   For more information, see **Setup.swift** implementation.
    open func setupConstraints() { }
}

