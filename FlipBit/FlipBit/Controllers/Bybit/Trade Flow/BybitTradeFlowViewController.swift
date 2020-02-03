//
//  BybitTradeFlowViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeFlowViewController: BaseTableViewController {
    
    private let order: Order
    private var pageIndex: Int = 0
    private lazy var viewControllers: [BaseTradeFlowViewController] = {
        return [TradeFlowTypeViewController(order: order), TradeFlowPriceViewController(order: order), TradeFlowQuantityViewController(order: order), TradeFlowStopLossViewController(order: order), TradeFlowTakeProfitViewController(order: order)]
    }()
    
    enum Section: Int, CaseIterable {
        case type = 0
        case price = 1
        case quantity = 2
        case total = 3
        
        var title: String? {
            switch self {
            case .type:
                return Constant.type

            case .price:
                return Constant.price

            case .quantity:
                return Constant.quantity

            case .total:
                return Constant.total
            }
        }
    }
    
    private lazy var colorTheme: UIColor = {
        return (order.side == .Buy) ? themeManager.buyTextColor : themeManager.sellTextColor
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(title: Constant.next, textColor: colorTheme, font: .body)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = colorTheme.cgColor
        button.isSelected = true
        return button
    }()
    
    init(order: Order) {
        self.order = order
        super.init(configuration: .none)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setFrameLengthByPercentage(width: 0.85, height: 0.6)
        view.setToScreenCenter()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.register(OrderOptionsCell.self, forCellReuseIdentifier: OrderOptionsCell.id)
        view.backgroundColor = themeManager.themeBackgroundColor.withAlphaComponent(0.7)
        tableView.backgroundColor = themeManager.themeBackgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        optionsBarIsHidden = true
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissTradeFlow(notification:)), name: .dismissFlow, object: nil)
        view.layer.cornerRadius = 14
        view.layer.borderColor = colorTheme.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(nextButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin16),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Space.margin16)
        ])
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> OrderOptionsCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderOptionsCell.id, for: indexPath) as? OrderOptionsCell
            else { return OrderOptionsCell() }
        cell.configure(title: "Order Type")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @objc func dismissTradeFlow(notification: NSNotification) { dismiss(animated: true) }
}
