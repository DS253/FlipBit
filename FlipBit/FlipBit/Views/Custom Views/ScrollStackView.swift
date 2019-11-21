//
//  ScrollStackView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

/// Provides all basic functionality to support a Scrollable `UIStackView`.
/// This `BaseView` subclass acts as a composite view of both a `UIScrollView`
/// and a `UIStackView` and manages the relationship between the two classes.
///
/// - Note:
///   Overrides the following methods:
///   - `setup()`
///   - `setupSubviews()`
///   - `setupConstraints()`
open class ScrollStackView: BaseView {
    /// The `UIScrollView` used to provide scrollability to `UIStackView`.
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    /// The `UIStackView` configured to scroll based on its `arrangedSubviews`.
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.backgroundColor = .white
        view.distribution = .fill
        view.spacing = 0.0
        view.axis = .horizontal

        return view
    }()

    // MARK: - Override Methods

    override open func setup() {
        super.setup()

        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }

    override open func setupSubviews() {
        super.setupSubviews()

        scrollView.addSubview(stackView)
        addSubview(scrollView)
    }

    override open func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    // MARK: - Private Methods

    /// Clears the `UIStackView` and then adds each `UIView` passed in.
    ///
    /// - Parameters:
    ///   - views:      The views to add to the underlying `UIStackView`.
    private func addSubviews(_ views: [UIView]?) {
        guard let views = views else { return }

        /// Remove all stackView arranged subviews before assigning new ones.
        clearStackView()

        views.forEach { stackView.addArrangedSubview($0) }
    }
}

// MARK: - Configuration

extension ScrollStackView {
    /// Configure a `ScrollStackView` with an array of `UIView` to add to the underlying `UIStackView`.
    ///
    /// - Parameters:
    ///   - views:            The views to add to the underlying `UIStackView`. Default Value: `nil`
    ///   - isHidden:         Sets the `hidden` property of the underlying `UIStackView`. Default Value: `false`
    ///   - isPagingEnabled:  Sets the value that determines if pagin is enabled. Default Value: `false`.
    public func configure(with views: [UIView]? = nil, isHidden: Bool = false, isPagingEnabled: Bool = false) {
        self.isHidden = isHidden
        scrollView.isPagingEnabled = isPagingEnabled

        addSubviews(views)
    }

    /// Adds an instance of `UIView` to the underlying `UIStackView` that can scroll based
    /// on its content.
    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    /// Removes all `arrangedSubviews` from the underlying `UIStackView`.
    public func clearStackView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    /// Provide access to the `arrangedSubviews` from the underlying `UIStackView`.
    public func arrangedSubviews() -> [UIView] {
        return stackView.arrangedSubviews
    }

    /// Scrolls to a given `CGPoint` on the underlying `UIScollView`.
    ///
    /// - Parameters:
    ///   - point:      The `CGPoint` in which to scroll to.
    ///   - animated:   Specify whether or not the scroll is animated.
    public func scrollContent(to point: CGPoint, animated: Bool) {
        scrollView.setContentOffset(point, animated: animated)
    }

    /// Returns the content offset of the scroll view
    public func contentOffset() -> CGPoint {
        return scrollView.contentOffset
    }
}
