//
//  Stepper.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/26/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

protocol StepperObserver: class {
    func stepperUpdated()
}

class Stepper: View {
    
    // MARK: - Public Properties
    
    var maxValue: Double
    var minValue: Double
    var increment: Double
    
    var timer: Timer?
    
    weak var observer: StepperObserver?
    
    var value: Double {
        didSet {
            if value < minValue { value = minValue }
            if value > maxValue { value = maxValue }
            
            textField.text = increment < 1 ? String(format: "%.2f", value) : String(format: "%.0f", value)
        }
    }
    
    lazy var textField: FlipBitTextField = {
        let field = FlipBitTextField(keyboardType: .decimalPad, textColor: themeManager.buyTextColor, font: .body, textAlignment: .center)
        field.backgroundColor = .clear
        field.layer.borderColor = themeManager.buyTextColor.cgColor
        field.layer.borderWidth = 2.0
        field.layer.cornerRadius = 7.0
        field.delegate = self
        return field
    }()
    
    // MARK: - Private Properties
    
    private let initialValue: Double
    
    private lazy var decrementer: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(name: .minus), for: .normal)
        button.setImage(UIImage(name: .minus), for: .disabled)
        button.tintColor = themeManager.buyTextColor
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(decrementerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var incrementer: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(name: .plus), for: .normal)
        button.setImage(UIImage(name: .plus), for: .disabled)
        button.tintColor = themeManager.buyTextColor
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(incrementerTapped), for: .touchUpInside)
        return button
    }()
    
    private let side: Bybit.Side
    private lazy var colorTheme: UIColor = {
        return (side == .Buy) ? themeManager.buyTextColor : themeManager.sellTextColor
    }()
    
    // MARK: - Initializers
    
    init(side: Bybit.Side = .None,
         observer stepperObserver: StepperObserver,
         delegate textFieldDelegate: UITextFieldDelegate,
         value initialValue: Double = 0.0,
         increment: Double = 1.0,
         max: Double = 0.0,
         min: Double = 0.0) {
        self.side = side
        self.increment = increment
        self.maxValue = max
        self.minValue = min
        self.initialValue = initialValue
        self.value = initialValue
        super.init()
        self.observer = stepperObserver
        self.textField.delegate = textFieldDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    override func setup() {
        super.setup()
        value = initialValue
        
        decrementer.addTarget(self, action: #selector(decrementerHold), for: .touchDown)
        decrementer.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        incrementer.addTarget(self, action: #selector(incrementerHold), for: .touchDown)
        incrementer.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(decrementer)
        addSubview(textField)
        addSubview(incrementer)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let buttonWidth: CGFloat = 42.0
        
        NSLayoutConstraint.activate([
            decrementer.leadingAnchor.constraint(equalTo: leadingAnchor),
            decrementer.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin8),
            decrementer.bottomAnchor.constraint(equalTo: bottomAnchor),
            decrementer.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            textField.leadingAnchor.constraint(equalTo: decrementer.trailingAnchor, constant: Space.margin8),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            incrementer.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: Space.margin8),
            incrementer.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin8),
            incrementer.bottomAnchor.constraint(equalTo: bottomAnchor),
            incrementer.trailingAnchor.constraint(equalTo: trailingAnchor),
            incrementer.widthAnchor.constraint(equalToConstant: buttonWidth),
        ])
    }
    
    // MARK: - Actions
    
    @objc func decrementerTapped() {
        textField.resignFirstResponder()
        value -= increment
        observer?.stepperUpdated()
    }
    
    @objc func decrementerHold() {
        textField.resignFirstResponder()
        timer = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(decrementerTapped), userInfo: nil, repeats: true)
    }
    
    @objc func incrementerTapped() {
        textField.resignFirstResponder()
        value += increment
        observer?.stepperUpdated()
    }
    
    @objc func incrementerHold() {
        textField.resignFirstResponder()
        timer = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(incrementerTapped), userInfo: nil, repeats: true)
    }
    
    @objc func buttonReleased() {
        timer?.invalidate()
    }
}

extension Stepper: PriceSelection {
    func priceSelected(price: String) {
        textField.text = price
        guard let double = Double(price) else { return }
        value = double
    }
}

extension Stepper: QuantitySelection {
    func quantitySelected(quantity: String) {
        textField.text = quantity
        guard let double = Double(quantity) else { return }
        value = double
    }
}

extension Stepper: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            let string = textField.text,
            let newValue = Double(string),
            newValue != 0
            else {
                textField.text = increment < 1 ? String(format: "%.2f", value) : String(format: "%.0f", value)
                return }
        value = newValue
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
                /// Only allow two characters after ".".
            else if arrayText[1].count == 2 {
                return false
            }
        }
        return true
    }
}
