//
//  OrderBookPanel.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/30/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class OrderBookPanel: View {
    
    private lazy var bookHeader: View = { View(backgroundColor: themeManager.themeBackgroundColor) }()
    
    private lazy var priceHeaderLabel: UILabel = {
        UILabel(text: Constant.price, font: UIFont.footnote, textColor: themeManager.themeFontColor, textAlignment: .left)
    }()
    
    private lazy var quantityHeaderLabel: UILabel = {
        UILabel(text: Constant.quantity, font: UIFont.footnote, textColor: themeManager.themeFontColor, textAlignment: .right)
    }()
        
    /// Lists the upcoming buy orders.
    private lazy var buybook: BuyOrderBookView = {
        BuyOrderBookView()
    }()
    
    /// Lists the upcoming sell orders.
    private lazy var sellbook: SellOrderBookView = {
        SellOrderBookView()
    }()
    
    override func setup() {
        super.setup()
        backgroundColor = themeManager.themeBackgroundColor
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(bookHeader)
        addSubview(buybook)
        addSubview(sellbook)
        
        bookHeader.addSubview(priceHeaderLabel)
        bookHeader.addSubview(quantityHeaderLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        bookHeader.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Space.margin16)
        }
        
        priceHeaderLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(bookHeader)
            make.leading.equalTo(bookHeader.snp.leading).inset(Space.margin8)
            make.trailing.equalTo(quantityHeaderLabel.snp.leading)
        }
        
        quantityHeaderLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(bookHeader)
        }
        
        buybook.snp.makeConstraints { make in
            make.top.equalTo(bookHeader.snp.bottom).offset(Space.margin4)
            make.trailing.equalToSuperview().inset(Space.margin16)
            make.leading.equalTo(sellbook.snp.trailing)
            make.width.equalTo(sellbook.snp.width)
        }
        
        sellbook.snp.makeConstraints { make in
            make.top.equalTo(bookHeader.snp.bottom).offset(Space.margin4)
            make.leading.equalToSuperview().inset(Space.margin16)
            make.bottom.equalToSuperview()
        }
    }
}
