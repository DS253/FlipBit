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
    
    /// The most recent price selected.
    private var currentValue: String = "" {
        didSet {
            guard let doubleValue = Double(currentValue) else { return }
            priceStepper.value = doubleValue
            priceStepper.textField.text = String(format: "%.2f", doubleValue)
            updateButtonState()
        }
    }
    
    /// Delegate observer tracks changes to the set price.
    private weak var priceDelegate: PriceObserver?
    
    /// Tracks the dismissal of the numberpad by the Cancel button in the toolbar.
    private var manualCancel: Bool = false
    
    /// Headline.
    private lazy var priceTitleLabel: UILabel = {
        UILabel(text: Constant.price, font: UIFont.title1.bold, textColor: themeManager.buyTextColor, textAlignment: .center)
    }()
    
    /// Stepper component used to change the price value.
    private lazy var priceStepper: Stepper = {
        return Stepper(observer: self, delegate: self, value: (self.initialValue as NSString).doubleValue, increment: 0.5, max: maxBybitContracts, min: 0.0)
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(title: Constant.updatePrice, textColor: themeManager.buyTextColor, font: .body, enabled: false)
        button.addTarget(self, action: #selector(updatePrice(sender:)), for: .touchDown)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = themeManager.sellTextColor.cgColor
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(spacing: Space.margin20, views: [priceTitleLabel, priceStepper, updateButton])
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelNumberPad)))
        return stackView
    }()
    
    private lazy var numberToolBar: UIToolbar = {
        let cancelButton = UIBarButtonItem(title: Constant.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelNumberPad))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Constant.done, style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonPressed))
        return UIToolbar(barItems: [cancelButton, space, doneButton])
    }()
    
    // MARK: Initializers
    
    init(price: String, observer: PriceObserver) {
        super.init(nibName: nil, bundle: nil)
        self.priceDelegate = observer
        currentValue = price
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
        view.backgroundColor = themeManager.blackColor.withAlphaComponent(0.7)
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPriceView(notification:)), name: .dismissFlow, object: nil)
        priceStepper.textField.text = initialValue
        priceStepper.textField.inputAccessoryView = self.numberToolBar
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1.0
        view.layer.borderColor = themeManager.whiteColor.cgColor
        view.layer.masksToBounds = false
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(stackView)
        
        updateButtonState()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Space.margin16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Space.margin16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin16),
            priceStepper.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100)
        ])
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
    @objc private func dismissPriceView(notification: NSNotification) {
        if priceStepper.textField.isFirstResponder {
            priceStepper.textField.resignFirstResponder()
        } else { dismiss(animated: true) }
    }
    
    /// Set the new price.
    @objc private func updatePrice(sender: Any) {
        priceDelegate?.priceUpdated(price: priceStepper.textField.text ?? "")
        dismiss(animated: true)
        hapticFeedback()
    }
    
    /// Dismiss the numberpad.
    @objc private func cancelNumberPad() {
        manualCancel = true
        guard priceStepper.textField.isFirstResponder else { return }
        priceStepper.endEditing(true)
        hapticFeedback()
    }
    
    /// Dismiss the numberpad.
    @objc private func doneButtonPressed() {
        manualCancel = false
        priceStepper.endEditing(true)
        hapticFeedback()
    }
}

extension BybitPriceUpdateViewController: UITextFieldDelegate {
    
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
        currentValue = String(format: "%.2f", newValue)
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

extension BybitPriceUpdateViewController: StepperObserver {
    func stepperUpdated() {
        guard
            let text = priceStepper.textField.text,
            let value = Double(text)
            else { return }
        currentValue = String(format: "%.2f", value)
    }
}
