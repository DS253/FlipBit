//
//  TradeFlowTypeViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/28/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class TradeFlowTypeViewController: BaseTradeFlowViewController {
    
    private lazy var limitButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.limit, textColor: UIColor.flatGray)
        button.setTitleColor(colorTheme, for: .selected)
        button.addTarget(self, action: #selector(tradeTypeButtonSelected(sender:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.body
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.isSelected = true
        return button
    }()
    
    private lazy var marketButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.market, textColor: UIColor.Bybit.white)
        button.setTitleColor(colorTheme, for: .selected)
        button.addTarget(self, action: #selector(tradeTypeButtonSelected(sender:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.body
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    override func setup() {
        super.setup()
        configureTradeTypeButtons()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(limitButton)
        view.addSubview(marketButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            limitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            limitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin16),
            limitButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            
            marketButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            marketButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            marketButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin16)
        ])
    }
    
    private func configureTradeTypeButtons() {
        if marketButton.isSelected {
            marketButton.layer.borderColor = colorTheme.cgColor
            limitButton.layer.borderColor = UIColor.Bybit.white.cgColor
        } else {
            limitButton.layer.borderColor = colorTheme.cgColor
            marketButton.layer.borderColor = UIColor.Bybit.white.cgColor
        }
    }
    
    @objc func tradeTypeButtonSelected(sender: Any) {
        marketButton.isSelected.toggle()
        limitButton.isSelected = !marketButton.isSelected
        configureTradeTypeButtons()
    }
    
    @objc override func dismissTradeFlow(notification: NSNotification) {
        if isVisible { dismiss(animated: true) }
    }
}
