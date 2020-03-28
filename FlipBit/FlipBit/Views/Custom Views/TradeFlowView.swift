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
        let button = UIButton(type: .custom, title: Constant.buy, textColor: themeManager.buyTextColor, font: UIFont.title3.bold)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = themeManager.buyTextColor.cgColor
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    private lazy var sellButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.sell, textColor: themeManager.sellTextColor, font: UIFont.title3.bold)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = themeManager.sellTextColor.cgColor
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
        backgroundColor = themeManager.themeBackgroundColor
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(buyButton)
        addSubview(sellButton)
        
        addSublayer(topGradient)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        sellButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(Space.margin8)
            make.trailing.equalTo(self.snp.centerX).inset(Space.margin4)
            make.height.equalTo(Space.margin48)
        }
        
        buyButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(Space.margin8)
            make.leading.equalTo(self.snp.centerX).offset(Space.margin4)
            make.height.equalTo(sellButton.snp.height)
            make.width.equalTo(sellButton.snp.width)
        }
    }

    func configureButtons(_ target: Any?, action: Selector) {
        buyButton.addTarget(target, action: action, for: .touchUpInside)
        sellButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
