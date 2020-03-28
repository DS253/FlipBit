//
//  OrderBookPanel.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/30/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class OrderBookPanel: View {
    
    weak var priceSelector: PriceSelection?
    
    private lazy var bookHeader: View = { View(backgroundColor: themeManager.themeBackgroundColor) }()
    
    private lazy var priceHeaderLabel: UILabel = {
        UILabel(text: Constant.price, font: UIFont.footnote, textColor: themeManager.themeFontColor, textAlignment: .left)
    }()
    
    private lazy var quantityHeaderLabel: UILabel = {
        UILabel(text: Constant.quantity, font: UIFont.footnote, textColor: themeManager.themeFontColor, textAlignment: .right)
    }()
    
    /// Separates the header from the book order views.
    private lazy var separatorView: View = { View(backgroundColor: themeManager.themeFontColor) }()
    
    /// Lists the upcoming buy orders.
    private lazy var buybook: BuyOrderBookView = {
        let buyView = BuyOrderBookView()
        buyView.layer.cornerRadius = 7
        buyView.layer.masksToBounds = true
        buyView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return buyView
    }()
    
    /// Displays the most recent price.
    private lazy var lastPriceLabel: UILabel = {
        let label = UILabel(text: " ", font: UIFont.largeTitle.bold, textColor: themeManager.buyTextColor, textAlignment: .center)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priceTapped)))
        return label
    }()
    
    /// Displays the most recent mark price.
    private lazy var markPriceLabel: UILabel = {
        UILabel(text: " ", font: UIFont.footnote.bold, textColor: UIColor.Bybit.markPriceOrange)
    }()
    
    /// Displays the daily percentage change.
    private lazy var dayPercentageChangeLabel: UILabel = {
        UILabel(text: " ", font: UIFont.footnote.bold, textColor: UIColor.Bybit.orderbookGreen, textAlignment: .right)
    }()
    
    /// Lists the upcoming sell orders.
    private lazy var sellbook: SellOrderBookView = {
        let sellView = SellOrderBookView()
        sellView.configureViewForSellBook()
        sellView.layer.cornerRadius = 7
        sellView.layer.masksToBounds = true
        sellView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return sellView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLastPrice(notification:)), name: .symbolObserverUpdate, object: nil)
        backgroundColor = themeManager.themeBackgroundColor
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(bookHeader)
        addSubview(buybook)
        addSubview(lastPriceLabel)
        addSubview(dayPercentageChangeLabel)
        addSubview(markPriceLabel)
        addSubview(sellbook)
        
        bookHeader.addSubview(separatorView)
        bookHeader.addSubview(priceHeaderLabel)
        bookHeader.addSubview(quantityHeaderLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            bookHeader.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin16),
            bookHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin16),
            bookHeader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.margin16),
            
            separatorView.leadingAnchor.constraint(equalTo: priceHeaderLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: quantityHeaderLabel.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Space.margin1),
            separatorView.topAnchor.constraint(equalTo: bookHeader.bottomAnchor, constant: Space.margin4),
            
            priceHeaderLabel.topAnchor.constraint(equalTo: bookHeader.topAnchor),
            priceHeaderLabel.bottomAnchor.constraint(equalTo: bookHeader.bottomAnchor),
            priceHeaderLabel.leadingAnchor.constraint(equalTo: bookHeader.leadingAnchor, constant: Space.margin8),
            priceHeaderLabel.trailingAnchor.constraint(equalTo: quantityHeaderLabel.leadingAnchor),
            
            quantityHeaderLabel.topAnchor.constraint(equalTo: bookHeader.topAnchor),
            quantityHeaderLabel.bottomAnchor.constraint(equalTo: bookHeader.bottomAnchor),
            quantityHeaderLabel.trailingAnchor.constraint(equalTo: bookHeader.trailingAnchor),
            
            buybook.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Space.margin4),
            buybook.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin16),
            buybook.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.margin16),
            
            lastPriceLabel.topAnchor.constraint(equalTo: buybook.bottomAnchor),
            lastPriceLabel.centerXAnchor.constraint(equalTo: buybook.centerXAnchor),
            
            dayPercentageChangeLabel.topAnchor.constraint(equalTo: lastPriceLabel.bottomAnchor),
            dayPercentageChangeLabel.trailingAnchor.constraint(equalTo: lastPriceLabel.centerXAnchor, constant: -Space.margin4),
            dayPercentageChangeLabel.heightAnchor.constraint(equalTo: markPriceLabel.heightAnchor),
            
            markPriceLabel.topAnchor.constraint(equalTo: dayPercentageChangeLabel.topAnchor),
            markPriceLabel.leadingAnchor.constraint(equalTo: lastPriceLabel.centerXAnchor, constant: Space.margin4),
            
            sellbook.topAnchor.constraint(equalTo: markPriceLabel.bottomAnchor, constant: Space.margin4),
            sellbook.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin16),
            sellbook.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.margin16)
        ])
    }
    
    func setPriceSelector(selector: PriceSelection) {
        buybook.setPriceSelector(selector: selector)
        sellbook.setPriceSelector(selector: selector)
        priceSelector = selector
    }
    
    func setQuantitySelector(selector: QuantitySelection) {
        buybook.setQuantitySelector(selector: selector)
        sellbook.setQuantitySelector(selector: selector)
    }
    
    /// Update the related labels when a new data is available.
    @objc func updateLastPrice(notification: NSNotification) {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let lastPrice = newInfo.lastPrice {
            lastPriceLabel.text = lastPrice
            lastPriceLabel.textColor = Bybit().tickColor
        }
        if let markPrice = newInfo.markPrice {
            markPriceLabel.text = markPrice
        }
        
        if let percentge = newInfo.prevPcnt24H {
            dayPercentageChangeLabel.textColor = Bybit().percentageDifferenceColor
            dayPercentageChangeLabel.text = "\(percentge)%"
        }
    }
    
    /// Updates the selected price when the price is tapped.
    @objc func priceTapped() {
        guard let price = lastPriceLabel.text else { return }
        priceSelector?.priceSelected(price: price)
        hapticFeedback()
    }
}
