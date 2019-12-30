//
//  TradeFlowStopLossViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class TradeFlowStopLossViewController: BaseTradeFlowViewController {
    
    private lazy var stopLossStepper: Stepper = {
        if let quantity = Double(order.quantity) {
            return Stepper(title: Constant.stopLoss, side: order.side, initialValue: 0, increment: 1.0, max: 100000.0, min: 0.0)
        }
        return Stepper(title: Constant.takeProfit, side: order.side, initialValue: 0, increment: 1.0, max: 100000.0, min: 0.0)
    }()
    
    override func setup() {
        super.setup()
        stopLossStepper.textField.keyboardType = .numberPad
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(stopLossStepper)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            stopLossStepper.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            stopLossStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc override func dismissTradeFlow(notification: NSNotification) {
        if !isVisible { return }
        if stopLossStepper.textField.isFirstResponder {
            stopLossStepper.textField.resignFirstResponder()
        } else { dismiss(animated: true) }
    }
    
    @objc override func dismissTextField() {
        stopLossStepper.textField.resignFirstResponder()
    }
}
