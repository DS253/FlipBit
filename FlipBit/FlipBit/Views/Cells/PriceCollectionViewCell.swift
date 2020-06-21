//
//  PriceCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 6/19/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class PriceCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var currencySymbolLabel: UILabel = {
        UILabel(text: "$", font: UIFont.headline, textColor: .flatWhiteDark)
    }()
    
    private lazy var priceLabel: UILabel = {
        UILabel(font: UIFont.title1, textColor: .white)
    }()
    
    private lazy var currencyTypeLabel: UILabel = {
        UILabel(text: "USD", font: UIFont.body, textColor: .flatWhiteDark)
    }()
    
    private lazy var percentageLabel: UILabel = {
        UILabel(font: UIFont.title3, textColor: .white)
    }()
    
    private lazy var percentageSymbolLabel: UILabel = {
        UILabel(text: "%", font: UIFont.body, textColor: .flatWhiteDark)
    }()
    
    private lazy var topSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
    }()
    
    private lazy var bottomSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbolInfo(notification:)), name: .symbolObserverUpdate, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        contentView.addSubview(topSeparator)
        contentView.addSubview(priceLabel)
        contentView.addSubview(percentageLabel)
        contentView.addSubview(percentageSymbolLabel)
        contentView.addSubview(currencySymbolLabel)
        contentView.addSubview(currencyTypeLabel)
        contentView.addSubview(bottomSeparator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        topSeparator.snp.makeConstraints { make in
            make.height.equalTo(Space.margin1)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        currencySymbolLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(Space.margin16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin16)
            make.leading.equalTo(currencySymbolLabel.snp.trailing).offset(Space.margin2)
        }
        
        currencyTypeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(priceLabel.snp.trailing).offset(Space.margin2)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        percentageSymbolLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(percentageLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.height.equalTo(Space.margin1)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
    }
    
    func set(for symbol: Bybit.Symbol) {
        priceLabel.text = symbol.rawValue
    }
    
    func set(title: String) {
        priceLabel.text = title
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let lastPrice = newInfo.lastPrice {
            priceLabel.text = lastPrice
        }
        if let dayPercentage = newInfo.prevPcnt24H {
            percentageLabel.text = dayPercentage
        }
    }
}

