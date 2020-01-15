//
//  TradeFlowQuantityViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class TradeFlowQuantityViewController: BaseTradeFlowViewController {
    
    private lazy var quantityStepper: Stepper = {
        if let quantity = Double(order.quantity) {
            return Stepper(side: order.side, initialValue: quantity, increment: 1.0, max: 1000000.0, min: 0.0)
        }
        return Stepper(side: order.side, initialValue: 0, increment: 1.0, max: 1000000.0, min: 0.0)
    }()
    
    override func setup() {
        super.setup()
        quantityStepper.textField.keyboardType = .numberPad
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(quantityStepper)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            quantityStepper.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            quantityStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc override func dismissTradeFlow(notification: NSNotification) {
        if !isVisible { return }
        if quantityStepper.textField.isFirstResponder {
            quantityStepper.textField.resignFirstResponder()
        } else { dismiss(animated: true) }
    }
    
    @objc override func dismissTextField() {
        quantityStepper.textField.resignFirstResponder()
    }
}
