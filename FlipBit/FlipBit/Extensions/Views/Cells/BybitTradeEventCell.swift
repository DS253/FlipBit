//
//  BybitTradeEventCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/1/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeEventCell: BaseTableViewCell {
    
    var bookOrders: Bybit.BookOrder?
    
    private lazy var priceLabel: UILabel = { UILabel(font: UIFont.footnote.bold) }()
    
    private let quantityLabel: UILabel = { UILabel(font: UIFont.footnote, textColor: themeManager.themeFontColor, textAlignment: .right) }()
    
    // MARK: - Setup Methods
    
    override func setup() {
        super.setup()
        backgroundColor = themeManager.themeBackgroundColor
        selectionStyle = .none
        clipsToBounds = true
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(priceLabel)
        addSubview(quantityLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin4),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin4),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin16),
            priceLabel.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor),
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin4),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin4),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.margin16),
            quantityLabel.widthAnchor.constraint(equalTo: priceLabel.widthAnchor)
        ])
    }
}

extension BybitTradeEventCell {
    func configure(tradeEvent: Bybit.TradeEvent) {
        guard
            let price = tradeEvent.price,
            let quantity = tradeEvent.size
            else { return }
        
        priceLabel.textColor = tradeEvent.side == .Buy ? themeManager.buyTextColor : themeManager.sellTextColor
        priceLabel.text = String(format: "%.2f", price)
        quantityLabel.text = String(quantity)
    }
}
