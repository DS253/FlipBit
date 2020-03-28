//
//  SymbolInfoHeaderView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/27/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import UIKit

class SymbolInfoHeaderView: View {
    
    private lazy var titleStackView: UIStackView = {
        UIStackView(spacing: Space.margin1, views: [dayHighTitleLabel, dayLowTitleLabel, dayTurnoverTitleLabel, fundingRateTitleLabel, fundingCountdownTitleLabel])
    }()
    
    private lazy var dataStackView: UIStackView = {
        UIStackView(spacing: Space.margin1, views: [dayHighDataLabel, dayLowDataLabel, dayTurnoverDataLabel, fundingRateDataLabel, fundingCountdownDataLabel])
    }()
    
    private lazy var dayHighTitleLabel: UILabel = {
        UILabel(text: Constant.dayHighTitle, font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray, textAlignment: .right)
    }()
    
    private lazy var dayHighDataLabel: UILabel = {
        UILabel(text: " ", font: UIFont.caption.bold, textColor: themeManager.themeFontColor)
    }()
    
    private lazy var dayLowTitleLabel: UILabel = {
        UILabel(text: Constant.dayLowTitle, font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray, textAlignment: .right)
    }()
    
    private lazy var dayLowDataLabel: UILabel = {
        UILabel(text: " ", font: UIFont.caption.bold, textColor: themeManager.themeFontColor)
    }()
    
    private lazy var dayTurnoverTitleLabel: UILabel = {
        UILabel(text: Constant.dayTurnoverTitle, font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray, textAlignment: .right)
    }()
    
    private lazy var dayTurnoverDataLabel: UILabel = {
        UILabel(text: " ", font: UIFont.caption.bold, textColor: themeManager.themeFontColor)
    }()
    
    private lazy var fundingRateTitleLabel: UILabel = {
        UILabel(text: Constant.fundingRateTitle, font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray, textAlignment: .right)
    }()
    
    private lazy var fundingRateDataLabel: UILabel = {
        UILabel(text: " ", font: UIFont.caption.bold, textColor: themeManager.themeFontColor)
    }()
    
    private lazy var fundingCountdownTitleLabel: UILabel = {
        UILabel(text: Constant.fundingCountdownTitle, font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray, textAlignment: .right)
    }()
    
    private lazy var fundingCountdownDataLabel: UILabel = {
        UILabel(text: " ", font: UIFont.caption.bold, textColor: themeManager.themeFontColor)
    }()
    
    private lazy var symbolNameLabel: UILabel = {
        UILabel(text: " ", font: UIFont.title2.bold, textColor: UIColor.Bybit.titleGray)
    }()
    
    private lazy var balanceLabel: UILabel = {
        UILabel(text: "0 BTC", font: UIFont.footnote.bold, textColor: UIColor.Bybit.titleGray)
    }()
    
    private lazy var lastTradedPriceLabel: UILabel = {
        UILabel(text: " ", font: UIFont.title3.bold, textColor: UIColor.Bybit.orderbookGreen)
    }()
    
    private lazy var markPriceLabel: UILabel = {
        UILabel(text: " ", font: UIFont.footnote.bold, textColor: UIColor.Bybit.markPriceOrange)
    }()
    
    private lazy var dayPercentageChangeLabel: UILabel = {
        UILabel(text: " ", font: UIFont.footnote.bold, textColor: UIColor.Bybit.orderbookGreen)
    }()
    
    override init() {
        super.init()
        configureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: .balanceUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbolInfo(notification:)), name: .symbolObserverUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBalance(notification:)), name: .balanceUpdate, object: nil)
        backgroundColor = themeManager.themeBackgroundColor
        setBybitTheme()
        layer.cornerRadius = 0
        layer.borderWidth = 0
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(symbolNameLabel)
        addSubview(balanceLabel)
        addSubview(lastTradedPriceLabel)
        addSubview(markPriceLabel)
        addSubview(dayPercentageChangeLabel)
        
        addSubview(titleStackView)
        addSubview(dataStackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        symbolNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolNameLabel.snp.bottom).offset(Space.margin2)
            make.centerX.equalToSuperview()
        }
        
        lastTradedPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolNameLabel.snp.bottom).offset(Space.margin2)
            make.leading.equalToSuperview().offset(Space.margin8)
        }
        
        dayPercentageChangeLabel.snp.makeConstraints { make in
            make.top.equalTo(lastTradedPriceLabel.snp.bottom).offset(Space.margin2)
            make.leading.equalTo(lastTradedPriceLabel.snp.leading).offset(Space.margin8)
            make.trailing.equalTo(markPriceLabel.snp.leading)
        }
        
        markPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(dayPercentageChangeLabel.snp.top)
            make.leading.equalTo(lastTradedPriceLabel.snp.centerX)
            make.trailing.equalTo(lastTradedPriceLabel.snp.trailing)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(symbolNameLabel.snp.top)
        }
        
        dataStackView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.top)
            make.leading.equalTo(titleStackView.snp.trailing).offset(Space.margin8)
            make.trailing.equalToSuperview().inset(Space.margin8)
            make.bottom.equalToSuperview().inset(Space.margin8)
        }
    }
    
    func configureView() {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let symbolName = newInfo.symbol {
            symbolNameLabel.text = symbolName.rawValue }
        if let lastPrice = newInfo.lastPrice {
            lastTradedPriceLabel.text = lastPrice
            lastTradedPriceLabel.textColor = Bybit().tickColor
        }
        if let markPrice = newInfo.markPrice {
            markPriceLabel.text = markPrice
        }
        if let dayHighPrice = newInfo.highPrice24H {
            dayHighDataLabel.text = dayHighPrice
        }
        if let dayLowPrice = newInfo.lowPrice24H {
            dayLowDataLabel.text = dayLowPrice
        }
        if let dayTurnover = newInfo.turnover24H {
            dayTurnoverDataLabel.text = dayTurnover
        }
        if let dayPercentChange = newInfo.prevPcnt24H {
            dayPercentageChangeLabel.text = "\(dayPercentChange)%"
            dayPercentageChangeLabel.textColor = Bybit().percentageDifferenceColor
        }
        if let fundingRate = newInfo.fundingRate {
            fundingRateDataLabel.text = "\(fundingRate)%"
        }
        
        if let countdown = newInfo.countdownToFundingFee {
            fundingCountdownDataLabel.text = "\(countdown) \((countdown == 1) ? Constant.hour : Constant.hours)"
        }
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    @objc func updateBalance(notification: NSNotification) {
        guard
            let balance = balanceManager.btcPosition?.walletBalance
            else { return }
        balanceLabel.text = "\(String(balance)) BTC"
    }
}
