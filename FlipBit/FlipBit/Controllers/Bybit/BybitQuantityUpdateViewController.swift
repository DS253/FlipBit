//
//  BybitQuantityUpdateViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/18/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class BybitQuantityUpdateViewController: ViewController {
    
    // MARK: - Private Properties
    
    /// The initial set quantity.
    private var initialValue: String = ""
    
    /// The value the quantity is currently set to.
    private var currentValue: String = "" {
        didSet {
            guard let doubleValue = Double(currentValue) else { return }
            //            orderManager.update(quantity: currentValue)
            quantityStepper.value = doubleValue
            quantityStepper.textField.text = String(format: "%.0f", doubleValue)
            orderValueLabel.text = "\(orderManager.orderValue)"
            orderCostLabel.text = "\(orderManager.provideEstimatedOrderValue())"
            updateButtonState()
        }
    }
    
    private var orderManager: OrderManager {
        OrderManager(price: (self.price as NSString).doubleValue, quantity: (currentValue as NSString).doubleValue, leverage: (self.leverage as NSString).doubleValue, tradeType: .Buy)
    }
        
    /// Tracks the dismissal of the numberpad by the Cancel button in the toolbar.
    private var manualCancel: Bool = false
    
    /// Main title label.
    private lazy var quantityTitleLabel: UILabel = {
        UILabel(text: Constant.quantity, font: UIFont.title1.bold, textColor: themeManager.buyTextColor, textAlignment: .center)
    }()
    
    /// Displays the account balance.
    private lazy var balanceLabel: UILabel = {
        if let balance = balanceManager.btcPosition?.walletBalance {
            return UILabel(text: "\(String(balance)) BTC", font: UIFont.footnote.bold, textColor: themeManager.buyTextColor, textAlignment: .center)
        }
        return UILabel(font: UIFont.footnote.bold, textColor: themeManager.buyTextColor, textAlignment: .center)
    }()
    
    /// Stepper component used to change the quantity value.
    private lazy var quantityStepper: Stepper = {
        return Stepper(observer: self, delegate: self, value: (self.initialValue as NSString).doubleValue, max: maxBybitContracts, min: 0.0)
    }()
    
    /// Button collection used to select a balance percentage.
    private lazy var percentageContainer: PercentageView = {
        let percentageView = PercentageView()
        percentageView.configureButtonActions(viewController: self, action: #selector(addByPercentage(sender:)), event: .touchUpInside)
        return percentageView
    }()
    
    /// Title for order value.
    private lazy var orderCostTitleLabel: UILabel = {
        UILabel(text: Constant.orderCost, font: UIFont.footnote.bold, textColor: themeManager.buyTextColor)
    }()
    
    private lazy var orderCostLabel: UILabel = {
        UILabel(text: "\(orderManager.provideEstimatedOrderValue())", font: UIFont.footnote.bold, textColor: themeManager.buyTextColor, textAlignment: .right)
    }()
    
    private lazy var costStackView: UIStackView = {
        UIStackView(axis: .horizontal, views: [orderCostTitleLabel, orderCostLabel])
    }()
    
    /// Title for order value.
    private lazy var orderValueTitleLabel: UILabel = {
        UILabel(text: Constant.orderValue, font: UIFont.footnote.bold, textColor: themeManager.buyTextColor)
    }()
    
    private lazy var orderValueLabel: UILabel = {
        UILabel(text: "\(orderManager.orderValue)", font: UIFont.footnote.bold, textColor: themeManager.buyTextColor, textAlignment: .right)
    }()
    
    private lazy var orderStackView: UIStackView = {
        UIStackView(axis: .horizontal, views: [orderValueTitleLabel, orderValueLabel])
    }()
    
    /// Title for leverage.
    private lazy var leverageTitleLabel: UILabel = {
        UILabel(text: Constant.leverage, font: UIFont.footnote.bold, textColor: themeManager.buyTextColor)
    }()
    
    /// Displays the current set leverage.
    private lazy var leverageLabel: UILabel = {
        if let balance = balanceManager.btcPosition?.walletBalance {
            return UILabel(text: self.leverage, font: UIFont.footnote.bold, textColor: themeManager.buyTextColor, textAlignment: .right)
        }
        return UILabel(font: UIFont.footnote.bold, textColor: themeManager.buyTextColor, textAlignment: .right)
    }()
    
    /// Stackview containing the title labels.
    private lazy var leverageStackView: UIStackView = {
        UIStackView(axis: .horizontal, views: [leverageTitleLabel, leverageLabel])
    }()
    
    /// Stackview containing the data labels.
    private lazy var dataStackView: UIStackView = {
        UIStackView(axis: .vertical, views: [orderStackView, costStackView, leverageStackView])
    }()
    
    /// Sets the current value to be the new quantity.
    private lazy var updateButton: UIButton = {
        let button = UIButton(title: Constant.updateQuantity, textColor: themeManager.buyTextColor, font: .body, enabled: false)
        button.addTarget(self, action: #selector(updatePrice(sender:)), for: .touchDown)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = themeManager.buyTextColor.cgColor
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        UIStackView(spacing: Space.margin14, views: [quantityTitleLabel, balanceLabel, quantityStepper, percentageContainer, dataStackView, updateButton])
    }()
    
    private lazy var numberToolBar: UIToolbar = {
        let cancelButton = UIBarButtonItem(title: Constant.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelNumberPad))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Constant.done, style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonPressed))
        return UIToolbar(barItems: [cancelButton, space, doneButton])
    }()
    
    private var price: String
    private var leverage: String
    
    // MARK: Initializers
    
    init(quantity: String, price: String, leverage: String) {
        self.price = price
        self.leverage = leverage
        super.init(nibName: nil, bundle: nil)
        currentValue = quantity
        initialValue = quantity
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
        NotificationCenter.default.addObserver(self, selector: #selector(dismissQuantityView(notification:)), name: .dismissFlow, object: nil)
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelNumberPad)))
        quantityStepper.textField.text = initialValue
        quantityStepper.textField.inputAccessoryView = self.numberToolBar
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.Bybit.white.cgColor
        view.layer.masksToBounds = false
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(stackView)
        
        updateButtonState()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(Space.margin16)
        }
        
        quantityStepper.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 100)
        }
    }
    
    /// Update the appearance and state of the Update button.
    private func updateButtonState() {
        /// If the value has changed since the initial value, the button is enabled.
        updateButton.isEnabled = initialValue != currentValue
        let color = updateButton.isEnabled ? themeManager.buyTextColor : themeManager.disabledTextColor
        updateButton.setTitleColor(color, for: .normal)
        updateButton.layer.borderColor = color.cgColor
    }
    
    /// Dismiss the view when tapped outside the view's bounds.
    @objc private func dismissQuantityView(notification: NSNotification) {
        if quantityStepper.textField.isFirstResponder {
            quantityStepper.textField.resignFirstResponder()
        } else { dismiss(animated: true) }
    }
    
    /// Set the new price.
    @objc private func updatePrice(sender: Any) {
        dismiss(animated: true)
        hapticFeedback()
    }
    
    /// Dismiss the numberpad.
    @objc private func cancelNumberPad() {
        manualCancel = true
        guard quantityStepper.textField.isFirstResponder else { return }
        quantityStepper.endEditing(true)
        hapticFeedback()
    }
    
    /// Dismiss the numberpad.
    @objc private func doneButtonPressed() {
        manualCancel = false
        quantityStepper.endEditing(true)
        hapticFeedback()
    }
    
    @objc func addByPercentage(sender: UIButton) {
        print(sender.titleLabel?.text as Any)
    }
}

extension BybitQuantityUpdateViewController: UITextFieldDelegate {
    /// Clear textField.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButton.isEnabled = false
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            manualCancel != true,
            let string = textField.text,
            let newValue = Double(string),
            newValue != 0
            else {
                textField.text = currentValue
                manualCancel = false
                updateButtonState()
                return
        }
        currentValue = String(format: "%.0f", newValue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// If backspace is pressed, allow it.
        if string.isBackSpace() { return true }
        let text = textField.text ?? ""
        
        if text.contains(".") {
            /// Only allow one "." in string.
            if string == "." { return false }
            let arrayText = text.components(separatedBy: ".")
            /// Only allow "5" or "0" as first character after ".".
            if arrayText[1].count == 0 {
                if (string == "5" || string == "0") {
                    textField.text?.append(contentsOf: string)
                    /// Append "0" as the final character.
                    textField.text?.append(contentsOf: "0")
                }
                return false
            }
            /// Only allow "0" as final character.
            if arrayText[1].count == 1 {
                textField.text?.append(contentsOf: "0")
                return false
            }
            /// Only allow two characters after ".".
            if arrayText[1].count == 2 { return false }
        }
        return true
    }
}

extension BybitQuantityUpdateViewController: StepperObserver {
    func stepperUpdated() {
        guard
            let text = quantityStepper.textField.text,
            let value = Double(text)
            else { return }
        currentValue = String(format: "%.0f", value)
    }
}
