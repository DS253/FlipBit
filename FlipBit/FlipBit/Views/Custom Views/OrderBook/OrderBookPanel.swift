//
//  OrderBookPanel.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/30/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class OrderBookPanel: View {
    
    private lazy var bookHeader: View = {
        let header = View()
        header.backgroundColor = UIColor.Bybit.themeBlack
        return header
    }()
    
    private lazy var priceHeaderLabel: UILabel = {
        let label = UILabel(font: UIFont.footnote, textColor: UIColor.Bybit.white)
        label.backgroundColor = UIColor.Bybit.themeBlack
        label.textAlignment = .left
        label.text = Constant.price
        return label
    }()
    
    private lazy var quantityHeaderLabel: UILabel = {
        let label = UILabel(font: UIFont.footnote, textColor: UIColor.Bybit.white)
        label.backgroundColor = UIColor.Bybit.themeBlack
        label.textAlignment = .right
        label.text = Constant.quantity
        return label
    }()
    
    private lazy var separatorView: View = {
        let separator = View()
        separator.backgroundColor = UIColor.Bybit.white
        return separator
    }()
    
    private lazy var buybook: BuyOrderBookView = {
        let buyView = BuyOrderBookView()
        buyView.layer.cornerRadius = 7
        buyView.layer.masksToBounds = true
        buyView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return buyView
    }()
    
    private lazy var sellbook: SellOrderBookView = {
        let sellView = SellOrderBookView()
        sellView.configureViewForSellBook()
        sellView.layer.cornerRadius = 7
        sellView.layer.masksToBounds = true
        sellView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return sellView
    }()
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor.Bybit.themeBlack
        setBybitTheme()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(bookHeader)
        addSubview(buybook)
        addSubview(sellbook)
        
        bookHeader.addSubview(separatorView)
        bookHeader.addSubview(priceHeaderLabel)
        bookHeader.addSubview(quantityHeaderLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            bookHeader.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin16),
            bookHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin16),
            bookHeader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin16),
            
            separatorView.leadingAnchor.constraint(equalTo: priceHeaderLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: quantityHeaderLabel.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Dimensions.Space.margin1),
            separatorView.topAnchor.constraint(equalTo: bookHeader.bottomAnchor, constant: Dimensions.Space.margin4),
            
            priceHeaderLabel.topAnchor.constraint(equalTo: bookHeader.topAnchor),
            priceHeaderLabel.bottomAnchor.constraint(equalTo: bookHeader.bottomAnchor),
            priceHeaderLabel.leadingAnchor.constraint(equalTo: bookHeader.leadingAnchor, constant: Dimensions.Space.margin8),
            priceHeaderLabel.trailingAnchor.constraint(equalTo: quantityHeaderLabel.leadingAnchor),
            
            quantityHeaderLabel.topAnchor.constraint(equalTo: bookHeader.topAnchor),
            quantityHeaderLabel.bottomAnchor.constraint(equalTo: bookHeader.bottomAnchor),
            quantityHeaderLabel.trailingAnchor.constraint(equalTo: bookHeader.trailingAnchor),
            
            buybook.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Dimensions.Space.margin4),
            buybook.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin16),
            buybook.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin16),

            sellbook.topAnchor.constraint(equalTo: buybook.bottomAnchor, constant: Dimensions.Space.margin16),
            sellbook.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin16),
            sellbook.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin16),
            sellbook.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin16)
        ])
    }
}