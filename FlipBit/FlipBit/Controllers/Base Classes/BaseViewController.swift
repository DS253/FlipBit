//
//  BaseViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

/// Provides all basic functionality of `UIViewController` with the
/// addition of some basic shared functionality that should be
/// adopted by all `UIViewController` subclasses.
///
/// - Note:
///   Overrides the following methods:
///   - `viewDidLoad()`
///
///   Conforms to the following Protocols:
///   - `ViewSetup`
///
///   The `Setup` methods are called in the following order:
///   - `setup()`
///   - `setupSubviews()`
///   - `setupConstraints()`
///
///   For more information, see **Setup.swift** implementation.
class BaseViewController: UIViewController, ViewSetup {
    /// Calls to each `setup` method in this order. Each of these methods
    /// are optional to implement dependant upon needs.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupSubviews()
        setupConstraints()
    }
    
    /// Allows for isolated setup of anything relating to `ViewController`.
    /// This is ideally where setup of model data or layout should occur.
    ///
    /// - Note:
    ///   Called in `viewDidLoad()` immediately following the call to `super.viewDidLoad()`
    ///
    ///   For more information, see **Setup.swift** implementation.
    func setup() { }
    
    /// Allows for isolated setup of **subviews** relating to this `ViewController`.
    /// This can include layout, configuration, customization, etc.
    ///
    /// - Note:
    ///   Called in `viewDidLoad()` immediately following the call to `setup()`
    ///
    ///   For more information, see **Setup.swift** implementation.
    func setupSubviews() { }
    
    /// Allows for isolated setup of **constraints** relating to this `ViewController`.
    /// This should only include configuration of any `NSLayoutConstraint` relating
    /// to this specific `ViewController` or it's subviews.
    ///
    /// - Note:
    ///   Called in `viewDidLoad()` immediately following the call to `setupSubviews()`
    ///
    ///   For more information, see **Setup.swift** implementation.
    func setupConstraints() { }
    
    let indicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.backgroundColor = .clear
        indicatorView.startAnimating()
        return indicatorView
    }()
}
