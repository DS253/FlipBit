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
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.margin4)
            make.bottom.equalToSuperview().inset(Space.margin4)
            make.leading.equalToSuperview().inset(Space.margin16)
            make.trailing.equalTo(quantityLabel.snp.leading)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.margin4)
            make.bottom.equalToSuperview().inset(Space.margin4)
            make.trailing.equalToSuperview().inset(Space.margin16)
            make.width.equalTo(priceLabel.snp.width)
        }
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
