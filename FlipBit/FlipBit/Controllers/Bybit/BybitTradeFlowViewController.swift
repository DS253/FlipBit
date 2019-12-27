//
//  BybitTradeFlowViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeFlowViewController: ViewController {
    
    private let side: Bybit.Side
    private let initialPrice: String
    private let quantity: String
    
    private lazy var colorTheme: UIColor = {
        return (side == .Buy) ? UIColor.flatMint : UIColor.flatWatermelon
    }()
    
    private let backgroundView: View = {
        let view = View()
        view.backgroundColor = .white
        return view
    }()
    
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
    
    private lazy var priceStepper: Stepper = {
        if let price = Double(self.initialPrice) {
            return Stepper(title: Constant.price, side: side, initialValue: price, increment: 0.5, max: 10000.0, min: 0.0)
        }
        return Stepper(title: Constant.price, side: side, initialValue: 0, increment: 0.5, max: 10000.0, min: 0.0)
    }()
    
    private lazy var quantityStepper: Stepper = {
        if let quantity = Double(self.quantity) {
            return Stepper(title: Constant.quantity, side: side, initialValue: quantity, increment: 1.0, max: 1000000.0, min: 0.0)
        }
        return Stepper(title: Constant.quantity, side: side, initialValue: 0, increment: 1.0, max: 1000000.0, min: 0.0)
    }()
    
    private lazy var takeProfitStepper: Stepper = {
        if let quantity = Double(self.quantity) {
            return Stepper(title: Constant.takeProfit, side: side, initialValue: 0, increment: 1.0, max: 100000.0, min: 0.0)
        }
        return Stepper(title: Constant.takeProfit, side: side, initialValue: 0, increment: 1.0, max: 100000.0, min: 0.0)
    }()
    
    private lazy var stopLossStepper: Stepper = {
        if let quantity = Double(self.quantity) {
            return Stepper(title: Constant.stopLoss, side: side, initialValue: 0, increment: 1.0, max: 100000.0, min: 0.0)
        }
        return Stepper(title: Constant.takeProfit, side: side, initialValue: 0, increment: 1.0, max: 100000.0, min: 0.0)
    }()
    
    init(side: Bybit.Side, price: String, quantity: String) {
        self.side = side
        self.initialPrice = price
        self.quantity = quantity
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dismissFlow, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.setFrameLengthByPercentage(width: 0.75, height: 0.75)
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissTradeFlow(notification:)), name: .dismissFlow, object: nil)
        priceStepper.textField.keyboardType = .numberPad
        quantityStepper.textField.keyboardType = .numberPad
        takeProfitStepper.textField.keyboardType = .numberPad
        stopLossStepper.textField.keyboardType = .numberPad
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTextField)))
        view.layer.cornerRadius = 14
        view.layer.borderColor = colorTheme.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        configureTradeTypeButtons()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(limitButton)
        view.addSubview(marketButton)
        view.addSubview(priceStepper)
        view.addSubview(quantityStepper)
        view.addSubview(takeProfitStepper)
        view.addSubview(stopLossStepper)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            limitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            limitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin16),
            limitButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            
            marketButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            marketButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            marketButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin16),
            
            priceStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceStepper.topAnchor.constraint(equalTo: limitButton.bottomAnchor, constant: Dimensions.Space.margin16),
            
            quantityStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quantityStepper.topAnchor.constraint(equalTo: priceStepper.bottomAnchor, constant: Dimensions.Space.margin16),
            
            takeProfitStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            takeProfitStepper.topAnchor.constraint(equalTo: quantityStepper.bottomAnchor, constant: Dimensions.Space.margin16),
            
            stopLossStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopLossStepper.topAnchor.constraint(equalTo: takeProfitStepper.bottomAnchor, constant: Dimensions.Space.margin16)
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
    
    @objc func dismissTextField() {
        priceStepper.textField.resignFirstResponder()
        quantityStepper.textField.resignFirstResponder()
        takeProfitStepper.textField.resignFirstResponder()
        stopLossStepper.textField.resignFirstResponder()
    }
    
    @objc func dismissTradeFlow(notification: NSNotification) {
        if priceStepper.textField.isFirstResponder {
            priceStepper.textField.resignFirstResponder()
        } else if quantityStepper.textField.isFirstResponder {
            quantityStepper.textField.resignFirstResponder()
        } else if takeProfitStepper.textField.isFirstResponder {
            takeProfitStepper.textField.resignFirstResponder()
        } else if stopLossStepper.textField.isFirstResponder {
            stopLossStepper.textField.resignFirstResponder()
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc func tradeTypeButtonSelected(sender: Any) {
        marketButton.isSelected.toggle()
        limitButton.isSelected = !marketButton.isSelected
        configureTradeTypeButtons()
    }
}
