//
//  BybitLeverageUpdateViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/5/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

protocol LeverageObserver: class {
    func leverageUpdated(leverage: String)
}

class BybitLeverageUpdateViewController: ViewController {
    
    // MARK: - Private Properties
    
    /// The maximum leverage that can be applied.
    private var maxValue: Int = 100
    
    /// The minimum leverage that can be applied.
    private var minValue: Int = 0
    
    /// The initial set leverage.
    private var initialValue: String = ""
    
    /// The current leverage manually set on the UISlider.
    private var currentValue: Int {
        didSet {
            if currentValue < minValue { currentValue = minValue }
            if currentValue > maxValue { currentValue = maxValue }
            
            leverageValueTextField.text = (currentValue == 0) ? Constant.cross : "\(String(currentValue))x"
            updateButtonState()
        }
    }
    
    /// Delegate observer tracks changes to the set leverage.
    private weak var leverageDelegate: LeverageObserver?
    
    /// Tracks the dismissal of the numberpad by the Cancel button in the toolbar.
    private var manualCancel: Bool = false
    
    private lazy var leverageTitleLabel: UILabel = {
        UILabel(text: Constant.leverage, font: UIFont.title1.bold, textColor: themeManager.buyTextColor, textAlignment: .center)
    }()
    
    private lazy var leverageValueTextField: FlipBitTextField = {
        let field = FlipBitTextField(keyboardType: .numberPad, textColor: themeManager.buyTextColor, font: UIFont.largeTitle.bold, textAlignment: .center)
        field.inputAccessoryView = self.numberToolBar
        field.backgroundColor = .clear
        field.layer.borderColor = themeManager.buyTextColor.cgColor
        field.layer.borderWidth = 2.0
        field.layer.cornerRadius = 7.0
        field.delegate = self
        return field
    }()
    
    private lazy var numberToolBar: UIToolbar = {
        let cancelButton = UIBarButtonItem(title: Constant.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelNumberPad))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Constant.done, style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonPressed))
        return UIToolbar(barItems: [cancelButton, space, doneButton])
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderAction(sender:)), for: .valueChanged)
        slider.minimumTrackTintColor = themeManager.buyTextColor
        slider.maximumTrackTintColor = themeManager.buyTextColor
        return slider
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(title: Constant.updateLeverage, textColor: themeManager.buyTextColor, font: .body)
        button.addTarget(self, action: #selector(updateLeverage(sender:)), for: .touchDown)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = themeManager.buyTextColor.cgColor
        button.isSelected = true
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(spacing: Space.margin20, views: [leverageTitleLabel, leverageValueTextField, slider, updateButton])
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelNumberPad)))
        return stackView
    }()
    
    // MARK: Initializers
    
    init(leverage: String, observer: LeverageObserver) {
        initialValue = leverage
        currentValue = (initialValue as NSString).integerValue
        super.init(nibName: nil, bundle: nil)
        self.leverageDelegate = observer
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
        NotificationCenter.default.addObserver(self, selector: #selector(dismissLeverageView(notification:)), name: .dismissFlow, object: nil)
        slider.value = (initialValue as NSString).floatValue
        updateLeverageValue(value: initialValue)
        
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
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(Space.margin16)
        }
        
        slider.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 100)
        }
    }
    
    /// Updates the current value and the textfield.
    private func updateLeverageValue(value: String) {
        currentValue = (value == "0") ? 0 : (value as NSString).integerValue
        leverageValueTextField.text = (value == "0") ? Constant.cross : (value + "x")
    }
    
    /// Update the appearance and state of the Update button.
    private func updateButtonState() {
        /// If the value has changed since the initial value, the button is enabled.
        updateButton.isEnabled = (initialValue != String(currentValue))
        let color = updateButton.isEnabled ? themeManager.buyTextColor : themeManager.disabledTextColor
        updateButton.setTitleColor(color, for: .normal)
        updateButton.layer.borderColor = color.cgColor
    }
    
    // MARK: Action Methods
    
    /// When the UISlider is adjusted, update the textfield and value properties.
    @objc private func sliderAction(sender: UISlider) {
        if leverageValueTextField.isFirstResponder { leverageValueTextField.resignFirstResponder() }
        currentValue = Int(sender.value)
        updateLeverageValue(value: String(currentValue))
    }
    
    /// Make call to change leverage.
    @objc private func updateLeverage(sender: Any) {
        /// Animate the activity indicator.
        stackView.display(view: indicator)
        services.updateBybitLeverage(symbol: .BTC, leverage: String(Int(slider.value))) { result in
            switch result {
            case .success(_):
                self.leverageDelegate?.leverageUpdated(leverage: String(Int(self.slider.value)))
                self.dismiss(animated: true)
            case let.failure(error):
                print(error)
            }
        }
        hapticFeedback()
    }
    
    /// Dismiss the view when tapped outside the view's bounds.
    @objc private func dismissLeverageView(notification: NSNotification) {
        if leverageValueTextField.isFirstResponder {
            leverageValueTextField.resignFirstResponder()
        } else { dismiss(animated: true) }
    }
    
    /// Dismiss the numberpad.
    @objc private func cancelNumberPad() {
        manualCancel = true
        guard leverageValueTextField.isFirstResponder else { return }
        leverageValueTextField.resignFirstResponder()
        hapticFeedback()
    }
    
    /// Dismiss the numberpad.
    @objc private func doneButtonPressed() {
        manualCancel = false
        leverageValueTextField.resignFirstResponder()
        hapticFeedback()
    }
}

// MARK: UITextFieldDelegate
extension BybitLeverageUpdateViewController: UITextFieldDelegate {
    
    /// When the textfield is active, disable the update button.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButton.isEnabled = false
        leverageValueTextField.text = ""
    }
    
    /// When the textfield is no longer active, update the button state, the UISlider, and value properties.
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            manualCancel != true,
            let string = textField.text,
            let newValue = Int(string)
            else {
                textField.text = (currentValue == 0) ? Constant.cross : "\(String(currentValue))x"
                manualCancel = false
                updateButtonState()
                return
        }
        currentValue = newValue
        slider.value = Float(newValue)
    }
    
    /// Limit the input to a maximum of 3 characters.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        return text.appending(string).count <= 3
    }
}
