//
//  BaseTableHeaderView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

/// The `BaseTableHeaderViewResizeDelegate` protocol provides an interface used to respond to the resizing of a `BaseTableHeaderView`.
public protocol BaseTableHeaderViewResizeDelegate: class {
    /// Tells the `resizeDelegate` that the `headerView` instance has resized.
    ///
    /// - Note:
    ///   Use this method to respond to size changes as needed.
    ///
    /// - Parameters:
    ///   - `headerView`: The instance of `BaseTableHeaderView` that has been resized.
    func headerViewDidResize(_ headerView: BaseTableHeaderView)
}

/// Provides base functionality for the `tableHeaderView` of a `BaseTableViewController`.
/// `BaseTableHeaderView` is composed of multiple configurable components that manage it's
/// layout.
///
/// - Note:
///   - `BaseTableHeaderView` is designed to be subclassed as needed for additional
///   configuration required by the client.
///
///   Configurable view component heirarchy:
///   - `header`
///   - `stackView`
///   - `footerView`
///   - `banner`
open class BaseTableHeaderView: BaseView {
    /// Conform to the `resizeDelegate` to get notified of height changes.
    public weak var resizeDelegate: BaseTableHeaderViewResizeDelegate?

    /// UILabel - displayed banner notifying user they are on the testnet of the exchange
    var testNetBanner: View = {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        view.isHidden = true

        let banner = UILabel(font: UIFont.body.semibold, textColor: .white)
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.textAlignment = .center
        view.addSubview(banner)

        banner.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin10).isActive = true
        banner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Dimensions.Space.margin10).isActive = true
        banner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        return view
    }()

    /// Provides access to the underlying collection of tiles presented on the `BaseTableHeaderView`.
    public var allTiles: [UIView] { return stackView.arrangedSubviews() }

    /// Configurable `BaseView` instance that manages presentation of a `title` positioned at
    /// the top of the `BaseTableHeaderView`.
    ///
    /// - Note:
    ///     * To configure, use the `configure(_ headerInfo:)` method.
    public let header: BaseView = {
        let view = BaseView()
        view.addLine(.bottomEdge)

        return view
    }()

    /// Configurable `ScrollStackView` instance that manages presentation of mutiple `tiles` across the
    /// center of the `BaseTableHeaderView`. These `tiles` will scroll automatically when there
    /// are too many to present at once.
    ///
    /// - Note:
    ///     * To configure, refer to:
    ///         * `allTiles`
    ///         * `addTile(_ view:)`
    ///         * `clearTiles()`
    public let stackView: ScrollStackView = {
        let stackView = ScrollStackView()
        stackView.addLine(.bottomEdge)
        return stackView
    }()

    /// Configurable `BaseView` instance that manages presentation of a `title` positioned at
    /// the bottom of the `BaseTableHeaderView`.
    ///
    /// - Note:
    ///     - To configure, use the `configure(_ headerInfo:)` method.
    public let footerView: BaseView = {
        let view = BaseView()
        view.isHidden = true

        return view
    }()

    /// Configurable `UILabel` instance that manages presentation of meaningful information positioned at
    /// the bottom of the `BaseTableHeaderView`. To Present the banner to the user, use the
    ///
    /// - Note:
    ///     - To present the banner, use `showBanner(_ title:, withBannerColor:)`.
    public let banner: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.headline.bold
        label.textAlignment = .center
        label.backgroundColor = .green
        label.textColor = .white
        label.isHidden = true

        return label
    }()

    /// NSLayoutConstraint used to manage the appearance of the banner to display
    /// successful or unsuccessful actions performed by the user.
    private lazy var bannerHeightConstraint: NSLayoutConstraint = {
        banner.heightAnchor.constraint(equalToConstant: Dimensions.Space.margin40)
    }()

    /// NSLayoutConstraint used to manage the disappearance of the banner.
    /// Specifically used during the animation of the constraint
    private lazy var bannerMinimumHeightConstraint: NSLayoutConstraint = {
        banner.heightAnchor.constraint(equalToConstant: .zero)
    }()

    override open var intrinsicContentSize: CGSize { return parentStackView.frame.size }

    private var headerInfo: HeaderInfo? {
        didSet {
            guard let headerInfo = headerInfo else { return }
            updateAppearance(with: headerInfo)
        }
    }

    private let parentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.backgroundColor = .lightGray

        return stackView
    }()

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.title2

        return label
    }()

    private let footerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.title2

        return label
    }()

    // MARK: - Override Methods

    override open func setup() {
        super.setup()
    }

    override open func setupSubviews() {
        super.setupSubviews()

        parentStackView.addArrangedSubview(testNetBanner)
        parentStackView.addArrangedSubview(header)
        parentStackView.addArrangedSubview(stackView)
        parentStackView.addArrangedSubview(footerView)
        parentStackView.addArrangedSubview(banner)

        addSubview(parentStackView)

        header.addSubview(headerTitleLabel)
        footerView.addSubview(footerTitleLabel)
    }

    override open func setupConstraints() {
        super.setupConstraints()

        let headerViewHeight: CGFloat = 65.0
        let footerViewHeight: CGFloat = 65.0

        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: topAnchor),
            parentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            parentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            header.heightAnchor.constraint(equalToConstant: headerViewHeight),

            headerTitleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor,
                                                      constant: Dimensions.Space.margin20),

            stackView.widthAnchor.constraint(equalTo: parentStackView.widthAnchor),

            footerView.heightAnchor.constraint(equalToConstant: footerViewHeight),

            footerTitleLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            footerTitleLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor,
                                                      constant: Dimensions.Space.margin20),
            bannerHeightConstraint])
    }

    // MARK: - Private Methods

    private func updateAppearance(with headerInfo: HeaderInfo) {
        switch headerInfo {
        case let .both(title, footer):
            headerTitleLabel.text = title
            footerTitleLabel.text = footer
            footerView.isHidden = false
            updateLayout()

        case .title(let title):
            headerTitleLabel.text = title

        case .footer(let footer):
            footerTitleLabel.text = footer
            footerView.isHidden = false
            updateLayout()
        }
    }

    private func updateLayout(animated: Bool) {
        if animated {
            UIView.animate(withDuration: .standardAnimationTime) {
                self.updateLayout()
            }
        } else {
            updateLayout()
        }
    }

    public func updateLayout() {
        self.parentStackView.layoutIfNeeded()
        self.layoutIfNeeded()
        self.resizeDelegate?.headerViewDidResize(self)
    }
}


// MARK: - Configuration

extension BaseTableHeaderView {
    /// Enumeration with associated values intended to provide information to be displayed on
    /// an instance of `BaseTableHeaderView`.
    public enum HeaderInfo {
        /// Use this case to provide a title to the `header` of a `BaseTableHeaderView`.
        case title(title: String)

        /// Use this case to provide a title to the `footer` of a `BaseTableHeaderView`.
        case footer(footer: String)

        /// Use this case to provide a title to both the `header` and `footer` of a `BaseTableHeaderView`.
        case both(title: String, footer: String)
    }

    /// Present a *banner* to the user to provide context of some change.
    /// The banner is presented with the specified `title` and `bannerColor`.
    /// The banner is presented for a standard time of **3** seconds.
    ///
    /// - Parameters:
    ///   - title: The title/message to present on the banner.
    ///   - color: The color of the banner. *Default Value*: `Alaska.green`
    public func showBanner(_ title: String, withBannerColor color: UIColor = .green) {
        banner.backgroundColor = color
        banner.text = title
        banner.isHidden = false
        bannerHeightConstraint.isActive = true
        bannerMinimumHeightConstraint.isActive = false
        updateLayout(animated: true)

        wait(.seconds(3)) {
            UIView.animate(withDuration: .standardAnimationTime, animations: {
                self.bannerHeightConstraint.isActive = false
                self.bannerMinimumHeightConstraint.isActive = true
                self.updateLayout()
            }, completion: { _ in
                self.banner.isHidden = true
            })
        }
    }

    /// Add any `UIView` instance as an arranged subview to the underlying `UIStackView` instance.
    public func addTile(_ view: UIView, animated: Bool = false) {
        stackView.addArrangedSubview(view)
        updateLayout(animated: animated)
    }

    /// Clear out all `arrangedSubviews` from the underlying `UIStackView` instance.
    public func clearTiles() {
        stackView.clearStackView()
        updateLayout()
    }

    /// Configure the `title` and `footer` messages of a `BaseTableHeaderView`.
    ///
    /// - Parameters:
    ///     - headerInfo: `enum` case with associated values representing the information to configure.
    ///
    /// For more information, see `BaseTableHeaderView.HeaderInfo`.
    public func configure(_ headerInfo: HeaderInfo) {
        self.headerInfo = headerInfo
    }
}

