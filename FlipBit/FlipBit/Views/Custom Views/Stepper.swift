//
//  Stepper.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/26/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class Stepper: View {
    
    // MARK: - Public Properties
    
    var maxValue: Double
    var minValue: Double
    var increment: Double
    
    var timer: Timer?
    
    var value: Double {
        didSet {
            if value < minValue { value = minValue }
            if value > maxValue { value = maxValue }
            
            textField.text = increment < 1 ? String(format: "%.2f", value) : String(format: "%.0f", value)
        }
    }
    
    lazy var textField: FlipBitTextField = {
        let field = FlipBitTextField()
        field.keyboardType = .decimalPad
        field.font = .body
        field.textAlignment = .center
        field.textColor = UIColor.flatNavyBlue
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.layer.borderColor = UIColor.flatNavyBlue.cgColor
        field.layer.borderWidth = 2.0
        field.layer.cornerRadius = 7.0
        field.delegate = self
        return field
    }()
    
    // MARK: - Private Properties
    
    private let initialValue: Double
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(font: UIFont.footnote, textColor: UIColor.flatNavyBlue)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var decrementer: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(name: .minus), for: .normal)
        button.setImage(UIImage(name: .minus), for: .disabled)
        button.tintColor = UIColor.flatNavyBlue
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(decrementerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var incrementer: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(name: .plus), for: .normal)
        button.setImage(UIImage(name: .plus), for: .disabled)
        button.tintColor = UIColor.flatNavyBlue
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(incrementerTapped), for: .touchUpInside)
        return button
    }()
    
    private let side: Bybit.Side
    private lazy var colorTheme: UIColor = {
        return (side == .Buy) ? UIColor.flatMint : UIColor.flatWatermelon
    }()
    
    // MARK: - Initializers
    
    init(title: String, side: Bybit.Side = .None, initialValue: Double = 0.0, increment: Double = 1.0, max: Double = 0.0, min: Double = 0.0) {
        self.side = side
        self.increment = increment
        self.maxValue = max
        self.minValue = min
        self.initialValue = initialValue
        self.value = initialValue
        super.init()
        self.titleLabel.text = title
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
        
        addSubview(titleLabel)
        addSubview(decrementer)
        addSubview(textField)
        addSubview(incrementer)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let buttonWidth: CGFloat = 42.0
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            decrementer.leadingAnchor.constraint(equalTo: leadingAnchor),
            decrementer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Dimensions.Space.margin8),
            decrementer.bottomAnchor.constraint(equalTo: bottomAnchor),
            decrementer.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            textField.leadingAnchor.constraint(equalTo: decrementer.trailingAnchor, constant: Dimensions.Space.margin8),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Dimensions.Space.margin8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            incrementer.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: Dimensions.Space.margin8),
            incrementer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Dimensions.Space.margin8),
            incrementer.bottomAnchor.constraint(equalTo: bottomAnchor),
            incrementer.trailingAnchor.constraint(equalTo: trailingAnchor),
            incrementer.widthAnchor.constraint(equalToConstant: buttonWidth),
        ])
    }
    
    // MARK: - Actions
    
    @objc func decrementerTapped() {
        value -= increment
    }
    
    @objc func decrementerHold() {
        timer = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(decrementerTapped), userInfo: nil, repeats: true)
    }
    
    @objc func incrementerTapped() {
        value += increment
    }
    
    @objc func incrementerHold() {
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
}
