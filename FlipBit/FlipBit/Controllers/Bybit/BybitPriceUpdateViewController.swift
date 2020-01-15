//
//  BybitPriceUpdateViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/14/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

protocol PriceObserver: class {
    func priceUpdated(price: String)
}

class BybitPriceUpdateViewController: ViewController {
    
    // MARK: - Private Properties
    
    /// The initial set price.
    private var initialValue: String = ""
    
    /// Delegate observer tracks changes to the set price.
    private weak var priceDelegate: PriceObserver?
    
    private lazy var priceTitleLabel: UILabel = {
        let leverageLabel = UILabel(font: UIFont.title1.bold, textColor: UIColor.flatMint)
        leverageLabel.textAlignment = .center
        leverageLabel.text = Constant.price
        return leverageLabel
    }()
    
    private lazy var priceStepper: Stepper = {
        return Stepper(side: .None, initialValue: (self.initialValue as NSString).doubleValue, increment: 0.5, max: 1000000.0, min: 0.0)
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.updatePrice, textColor: UIColor.flatMintDark)
        button.addTarget(self, action: #selector(updatePrice(sender:)), for: .touchDown)
        button.titleLabel?.font = UIFont.body
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = UIColor.flatMintDark.cgColor
        button.isSelected = true
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Dimensions.Space.margin20
        stackView.addArrangedSubviews([priceTitleLabel, priceStepper, updateButton])
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelNumberPad)))
        return stackView
    }()
    
    // MARK: Initializers
    
    init(price: String, observer: PriceObserver) {
        super.init(nibName: nil, bundle: nil)
        self.priceDelegate = observer
        initialValue = price
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dismissFlow, object: nil)
    }
    
    // MARK: Setup
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPriceView(notification:)), name: .dismissFlow, object: nil)
        priceStepper.textField.text = initialValue
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.Bybit.white.cgColor
        view.layer.masksToBounds = false
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(stackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Dimensions.Space.margin16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin16),
            priceStepper.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100)
        ])
    }
    
    /// Dismiss the view when tapped outside the view's bounds.
    @objc private func dismissPriceView(notification: NSNotification) {
        if priceStepper.textField.isFirstResponder {
            priceStepper.textField.resignFirstResponder()
        } else { dismiss(animated: true) }
    }
    
    /// Set the new price.
    @objc private func updatePrice(sender: Any) {
        priceDelegate?.priceUpdated(price: priceStepper.textField.text ?? "")
        dismiss(animated: true)
        vibrate()
    }
    
    /// Dismiss the numberpad.
    @objc private func cancelNumberPad() {
        priceStepper.textField.resignFirstResponder()
        vibrate()
    }
}
