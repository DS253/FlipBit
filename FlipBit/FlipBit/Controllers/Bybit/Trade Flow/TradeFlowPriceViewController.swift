//
//  TradeFlowPriceViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class TradeFlowPriceViewController: BaseTradeFlowViewController {
    
//    private lazy var priceStepper: Stepper = {
//        if let price = Double(order.price) {
//            return Stepper(side: order.side, initialValue: price, increment: 0.5, max: 10000.0, min: 0.0)
//        }
//        return Stepper(side: order.side, initialValue: 0, increment: 0.5, max: 10000.0, min: 0.0)
//    }()
//
//    override func setup() {
//        super.setup()
//        priceStepper.textField.keyboardType = .numberPad
//    }
//
//    override func setupSubviews() {
//        super.setupSubviews()
//        view.addSubview(priceStepper)
//    }
//
//    override func setupConstraints() {
//        super.setupConstraints()
//        NSLayoutConstraint.activate([
//            priceStepper.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
//            priceStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//
//    @objc override func dismissTradeFlow(notification: NSNotification) {
//        if !isVisible { return }
//        if priceStepper.textField.isFirstResponder {
//            priceStepper.textField.resignFirstResponder()
//        } else { dismiss(animated: true) }
//    }
//
//    @objc override func dismissTextField() {
//        priceStepper.textField.resignFirstResponder()
//    }
}
