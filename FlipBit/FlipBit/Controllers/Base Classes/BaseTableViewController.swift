//
//  BaseTableViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

/// Provides logic for shared implementation used across all `BaseViewController`s.
/// This class provides a custom `tableHeaderView`, `tableView` and `optionsView`
/// to be configured and used as needed. This class **is** intended to be subclassed.
///
/// - Note:
///   The provided `UITableView` is configured with `automaticDimensions`
///   for it's `rowHeight`.
///
///   Overrides the following methods:
///   - `setup()`
///   - `setupSubviews()`
///   - `setupConstraints()`
class BaseTableViewController: BaseViewController {
    /// Defines the specified configurations for a `BaseTableViewController`.
    /// The default configuration is `standard`.
    public enum Configuration {
        /// Specifies a default configuration for an instance of `BaseTableViewController`.
        /// With the `default` configuration, the `tableHeaderView` scrolls with the `tableView` content.
        case `default`

        /// The `fixedHeader` configuration, specifies the `tableHeaderView` as fixed,
        /// and does **not** scroll with the `tableView` content.
        case fixedHeader
    }

    /// Override this property as needed to account for
    /// varying heights of `navigationBar`. Default: 0.0
    var topBarOffSet: CGFloat { return 0.0 }

    /// Unhide the bottom bar for providing additional options
    /// to the user when needed. Default: `true`
    public var optionsBarIsHidden: Bool = true {
        didSet { toggleOptionsView() }
    }

    /// The primary header of the table. This provides multiple
    /// views for configuration.
    ///
    /// - See Also: BaseTableHeaderView.swift
    public lazy var tableHeaderView: BaseTableHeaderView = {
        let headerView = BaseTableHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        headerView.resizeDelegate = self
        return headerView
    }()

    /// The primary tableview for displaying information relating
    /// to this controller.
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.9607340693, green: 0.9608191848, blue: 0.9606630206, alpha: 1)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    /// This view provides a context for presenting additional options
    /// to the user. When implemented, create a `UIView` subclass, and add
    /// it to this view using the `addOptionsView(_:)` method.
    public let optionsView: BaseView = BaseView()

    private lazy var optionsViewGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.15).cgColor,
            UIColor.black.withAlphaComponent(0.0).cgColor
        ]

        return gradient
    }()

    private let optionsViewGradientHeight: CGFloat = 4.0
    private let optionsBarOpenHeight: CGFloat = 90.0
    private var optionsBarHeightConstraint: NSLayoutConstraint?

    private let configuration: Configuration

    // MARK: - Initializers

    /// Initialize an instance of `BaseTableViewController` where `nibName` and `bundle` are `nil`.
    public init(configuration: Configuration = .default) {
        self.configuration = configuration

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        optionsViewGradient.frame = CGRect(
            x: .zero,
            y: .zero,
            width: tableView.bounds.size.width,
            height: optionsViewGradientHeight
        )
    }

    override func setup() {
        super.setup()

        view.backgroundColor = .white
    }

    override func setupSubviews() {
        super.setupSubviews()

        switch configuration {
        case .default:
            tableView.setHeaderView(tableHeaderView)

        case .fixedHeader:
            view.addSubview(tableHeaderView)
        }

        view.addSubview(tableView)
        view.addSubview(optionsView)
        optionsView.addSublayer(optionsViewGradient)
    }

    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: optionsView.topAnchor),

            optionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate(constraints(for: configuration))

        let optionsBarHeight = optionsBarIsHidden ? 0.0 : optionsBarOpenHeight
        optionsBarHeightConstraint = optionsView.heightAnchor.constraint(equalToConstant: optionsBarHeight)
        optionsBarHeightConstraint?.isActive = true
    }

    // MARK: - Private Methods

    private func toggleOptionsView() {
        optionsBarHeightConstraint?.constant = optionsBarIsHidden ? 0.0 : optionsBarOpenHeight
        UIView.animate(withDuration: .standardAnimationTime) { self.view.layoutIfNeeded() }
    }

    private func constraints(for configuration: Configuration) -> [NSLayoutConstraint] {
        switch configuration {
        case .default:
            return [tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarOffSet),
                    // Due to the strange behavior of `UITableView`'s `tableHeaderView` layout, these
                    // constraints are required as defined and should be modified with great CAUTION.
                    tableHeaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                    tableHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
                    tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor)]

        case .fixedHeader:
            return [tableView.topAnchor.constraint(equalTo: tableHeaderView.bottomAnchor),

                    tableHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarOffSet),
                    tableHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
        }
    }
}


// MARK: - Configuration

extension BaseTableViewController {
    public func addOptionsView(_ view: UIView) {
        optionsView.addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor),
            view.topAnchor.constraint(equalTo: optionsView.topAnchor),
            view.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor)
        ])
    }

    /// Customize the `tableHeaderView` layout.
    public func configureHeader(_ headerInfo: BaseTableHeaderView.HeaderInfo) {
        self.tableHeaderView.configure(headerInfo)
    }

    /// Presents a **Banner**, with the provided `title` and specified `bannerColor`,
    /// to the user for 3 seconds to provide information about any contextual information
    /// changes or updates.
    public func showBanner(_ title: String, withBannerColor color: UIColor = .green) {
        tableHeaderView.showBanner(title, withBannerColor: color)
    }
}

extension BaseTableViewController: BaseTableHeaderViewResizeDelegate {
    public func headerViewDidResize(_ headerView: BaseTableHeaderView) {
        tableView.tableHeaderView?.layoutIfNeeded()

        guard configuration != .fixedHeader else { return }
        // Due to some strange behavior associated to configuring `tableHeaderView` of `UITableView`,
        // This reassignment logic is needed to properly change or animate height changes.
        tableView.setHeaderView(headerView)
    }
}

