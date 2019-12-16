//
//  TradeFlowView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/15/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class TradeFlowView: BaseView {
    
    private lazy var topGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.flatNavyBlue.withAlphaComponent(0.45).cgColor,
            UIColor.flatNavyBlue.withAlphaComponent(0.0).cgColor
        ]

        return gradient
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.buy, textColor: UIColor.flatMint)
        button.titleLabel?.font = UIFont.title3.bold
        button.layer.borderWidth = 4.0
        button.layer.borderColor = UIColor.flatMint.cgColor
        button.layer.cornerRadius = 7.0
        button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sellButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.sell, textColor: UIColor.flatWatermelon)
        button.titleLabel?.font = UIFont.title3.bold
        button.layer.borderWidth = 4.0
        button.layer.borderColor = UIColor.flatWatermelon.cgColor
        button.layer.cornerRadius = 7.0
        button.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topGradient.frame = CGRect(x: .zero, y: .zero, width: bounds.size.width, height: 4.0)
    }
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor.Bybit.white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(buyButton)
        addSubview(sellButton)
        
        addSublayer(topGradient)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            sellButton.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin8),
            sellButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin8),
            sellButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin8),
            sellButton.trailingAnchor.constraint(equalTo: buyButton.leadingAnchor, constant: -Dimensions.Space.margin4),
            sellButton.heightAnchor.constraint(equalToConstant: Dimensions.Space.margin48),

            buyButton.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin8),
            buyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin8),
            buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin8),
            buyButton.heightAnchor.constraint(equalToConstant: Dimensions.Space.margin48),
            buyButton.widthAnchor.constraint(equalTo: sellButton.widthAnchor)
        ])
    }
    
    @objc func buyButtonTapped() {
        buyButton.isSelected.toggle()
    }
    
    @objc func sellButtonTapped() {
        sellButton.isSelected.toggle()
    }
}
