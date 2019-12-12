//
//  ValuePickerView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/7/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

protocol PriceSelection: class { func priceSelected(price: String) }

protocol QuantitySelection: class { func quantitySelected(quantity: String) }

class ValuePickerView: View, PriceSelection, QuantitySelection {

    private lazy var titleLabel: UILabel = {
        UILabel(font: UIFont.headline, textColor: UIColor.Bybit.themeBlack)
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(font: UIFont.headline, textColor: UIColor.Bybit.themeBlack)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .custom, title: "+", textColor: UIColor.Bybit.white)
        button.titleLabel?.font = UIFont.body.bold
        button.backgroundColor = UIColor.flatMint
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .custom, title: "-", textColor: UIColor.Bybit.white)
        button.titleLabel?.font = UIFont.body.bold
        button.backgroundColor = UIColor.flatWatermelon
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    init(title: String, value: String) {
        super.init()
        titleLabel.text = title
        valueLabel.text = value
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor.Bybit.white
        setBybitTheme()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(increaseButton)
        addSubview(decreaseButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin8),
            
            increaseButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Dimensions.Space.margin8),
            increaseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin8),
            increaseButton.widthAnchor.constraint(equalTo: decreaseButton.widthAnchor),
            increaseButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            decreaseButton.topAnchor.constraint(equalTo: increaseButton.bottomAnchor, constant: Dimensions.Space.margin4),
            decreaseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin8),
            decreaseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin8),
            decreaseButton.heightAnchor.constraint(equalTo: increaseButton.heightAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin8),
            valueLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureValueText(value: String) {
        valueLabel.text = value
    }

    func priceSelected(price: String) {
        valueLabel.text = price
    }

    func quantitySelected(quantity: String) {
        valueLabel.text = quantity
    }
}
