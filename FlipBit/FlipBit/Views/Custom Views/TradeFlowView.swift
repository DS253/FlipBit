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
        let button = UIButton(type: .custom, title: Constant.buy, textColor: UIColor.flatMint, font: UIFont.title3.bold)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.flatMint.cgColor
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    private lazy var sellButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.sell, textColor: UIColor.flatWatermelon, font: UIFont.title3.bold)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.flatWatermelon.cgColor
        button.layer.cornerRadius = 7.0
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
            sellButton.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin8),
            sellButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin8),
            sellButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin8),
            sellButton.trailingAnchor.constraint(equalTo: buyButton.leadingAnchor, constant: -Space.margin4),
            sellButton.heightAnchor.constraint(equalToConstant: Space.margin48),

            buyButton.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin8),
            buyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.margin8),
            buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin8),
            buyButton.heightAnchor.constraint(equalToConstant: Space.margin48),
            buyButton.widthAnchor.constraint(equalTo: sellButton.widthAnchor)
        ])
    }

    func configureButtons(_ target: Any?, action: Selector) {
        buyButton.addTarget(target, action: action, for: .touchUpInside)
        sellButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
