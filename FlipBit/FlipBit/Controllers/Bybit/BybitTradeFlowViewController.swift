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
        button.titleLabel?.font = UIFont.body.bold
        button.layer.borderWidth = 4.0
        button.layer.cornerRadius = 7.0
        button.isSelected = true
        return button
    }()
    
    private lazy var marketButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.market, textColor: UIColor.flatGray)
        button.setTitleColor(colorTheme, for: .selected)
        button.addTarget(self, action: #selector(tradeTypeButtonSelected(sender:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.body.bold
        button.layer.borderWidth = 4.0
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    private lazy var priceStepper: Stepper = {
        if let price = Double(self.initialPrice) {
            return Stepper(side: side, initialValue: price, increment: 0.5, max: 10000.0, min: 0.0)
        }
        return Stepper(side: side, initialValue: 0, increment: 0.5, max: 10000.0, min: 0.0)
    }()
    
    lazy var priceTextView: TitleTextView = {
        let textView = TitleTextView()
        textView.titleLabel.text = Constant.price
        textView.titleLabel.textColor = colorTheme
        textView.textField.keyboardType = .numberPad
        textView.textField.backgroundColor = .clear
        textView.textField.textColor = colorTheme
        textView.textField.delegate = self
        return textView
    }()
    
    lazy var quantityTextView: TitleTextView = {
        let textView = TitleTextView()
        textView.titleLabel.text = Constant.quantity
        textView.titleLabel.textColor = colorTheme
        textView.textField.keyboardType = .numberPad
        textView.textField.backgroundColor = .clear
        textView.textField.textColor = colorTheme
        textView.textField.delegate = self
        return textView
    }()
    
    init(side: Bybit.Side, price: String, quantity: String) {
        self.side = side
        self.initialPrice = price
        self.quantity = quantity
        super.init(nibName: nil, bundle: nil)
        priceTextView.textField.text = price
        quantityTextView.textField.text = quantity
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
        priceStepper.delegate = self
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
        view.addSubview(priceTextView)
        view.addSubview(quantityTextView)
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
            
            priceTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin16),
            priceTextView.topAnchor.constraint(equalTo: limitButton.bottomAnchor, constant: Dimensions.Space.margin16),
            
            priceStepper.leadingAnchor.constraint(equalTo: priceTextView.leadingAnchor),
            priceStepper.topAnchor.constraint(equalTo: priceTextView.bottomAnchor, constant: Dimensions.Space.margin16),
            
            quantityTextView.leadingAnchor.constraint(equalTo: priceStepper.leadingAnchor),
            quantityTextView.topAnchor.constraint(equalTo: priceStepper.bottomAnchor, constant: Dimensions.Space.margin16)
        ])
    }
    
    private func configureTradeTypeButtons() {
        if marketButton.isSelected {
            marketButton.layer.borderColor = colorTheme.cgColor
            limitButton.layer.borderColor = UIColor.flatGray.cgColor
        } else {
            limitButton.layer.borderColor = colorTheme.cgColor
            marketButton.layer.borderColor = UIColor.flatGray.cgColor
        }
    }
    
    @objc func dismissTextField() {
        priceTextView.textField.resignFirstResponder()
        quantityTextView.textField.resignFirstResponder()
    }
    
    @objc func dismissTradeFlow(notification: NSNotification) {
        if priceTextView.textField.isFirstResponder {
            priceTextView.textField.resignFirstResponder()
        } else if quantityTextView.textField.isFirstResponder {
            quantityTextView.textField.resignFirstResponder()
        }
        else {
            dismiss(animated: true)
        }
    }
    
    @objc func tradeTypeButtonSelected(sender: Any) {
        marketButton.isSelected.toggle()
        limitButton.isSelected = !marketButton.isSelected
        configureTradeTypeButtons()
    }
}

extension BybitTradeFlowViewController: StepperDelegate {
    
    func stepperDidUpdate(to value: Double) {
        
    }
}
