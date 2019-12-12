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
        
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dayHighTitleLabel: UILabel = {
        let dayHighLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray)
        dayHighLabel.textAlignment = .right
        dayHighLabel.text = Constant.dayHighTitle
        return dayHighLabel
    }()
    
    private lazy var dayHighDataLabel: UILabel = {
        let dayHighLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.themeBlack)
        dayHighLabel.text = " "
        dayHighLabel.textAlignment = .left
        return dayHighLabel
    }()
    
    private lazy var dayLowTitleLabel: UILabel = {
        let dayLowLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray)
        dayLowLabel.textAlignment = .right
        dayLowLabel.text = Constant.dayLowTitle
        return dayLowLabel
    }()
    
    private lazy var dayLowDataLabel: UILabel = {
        let dayLowLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.themeBlack)
        dayLowLabel.text = " "
        dayLowLabel.textAlignment = .left
        return dayLowLabel
    }()
    
    private lazy var dayTurnoverTitleLabel: UILabel = {
        let dayTurnoverLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray)
        dayTurnoverLabel.textAlignment = .right
        dayTurnoverLabel.text = Constant.dayTurnoverTitle
        return dayTurnoverLabel
    }()
    
    private lazy var dayTurnoverDataLabel: UILabel = {
        let dayTurnoverDataLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.themeBlack)
        dayTurnoverDataLabel.text = " "
        dayTurnoverDataLabel.textAlignment = .left
        return dayTurnoverDataLabel
    }()
    
    private lazy var fundingRateTitleLabel: UILabel = {
        let fundingTitle = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray)
        fundingTitle.textAlignment = .right
        fundingTitle.text = Constant.fundingRateTitle
        return fundingTitle
    }()
    
    private lazy var fundingRateDataLabel: UILabel = {
        let dayTurnoverDataLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.themeBlack)
        dayTurnoverDataLabel.text = " "
        dayTurnoverDataLabel.textAlignment = .left
        return dayTurnoverDataLabel
    }()
    
    private lazy var fundingCountdownTitleLabel: UILabel = {
        let countdownTitle = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.titleGray)
        countdownTitle.text = Constant.fundingCountdownTitle
        countdownTitle.textAlignment = .right
        return countdownTitle
    }()
    
    private lazy var fundingCountdownDataLabel: UILabel = {
        let dayTurnoverDataLabel = UILabel(font: UIFont.caption.bold, textColor: UIColor.Bybit.themeBlack)
        dayTurnoverDataLabel.text = " "
        dayTurnoverDataLabel.textAlignment = .left
        return dayTurnoverDataLabel
    }()
    
    private lazy var symbolNameLabel: UILabel = {
        let symbolLabel = UILabel(font: UIFont.title2.bold, textColor: UIColor.Bybit.titleGray)
        symbolLabel.text = " "
        return symbolLabel
    }()
    
    private lazy var lastTradedPriceLabel: UILabel = {
        let lastPriceLabel = UILabel(font: UIFont.title3.bold, textColor: UIColor.Bybit.orderbookGreen)
        lastPriceLabel.text = " "
        return lastPriceLabel
    }()
    
    private lazy var markPriceLabel: UILabel = {
        let markPriceLabel = UILabel(font: UIFont.footnote.bold, textColor: UIColor.Bybit.markPriceOrange)
         markPriceLabel.text = " "
        return markPriceLabel
    }()
    
    private lazy var dayPercentageChangeLabel: UILabel = {
        let percentLabel = UILabel(font: UIFont.footnote.bold, textColor: UIColor.Bybit.orderbookGreen)
        percentLabel.text = " "
        return percentLabel
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbolInfo(notification:)), name: .symbolObserverUpdate, object: nil)
        backgroundColor = UIColor.Bybit.white
        setBybitTheme()
        layer.cornerRadius = 0
        layer.borderWidth = 0
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(symbolNameLabel)
        addSubview(lastTradedPriceLabel)
        addSubview(markPriceLabel)
        addSubview(dayPercentageChangeLabel)
        
        addSubview(titleStackView)
        titleStackView.addArrangedSubview(dayHighTitleLabel)
        titleStackView.addArrangedSubview(dayLowTitleLabel)
        titleStackView.addArrangedSubview(dayTurnoverTitleLabel)
        titleStackView.addArrangedSubview(fundingRateTitleLabel)
        titleStackView.addArrangedSubview(fundingCountdownTitleLabel)
        
        addSubview(dataStackView)
        dataStackView.addArrangedSubview(dayHighDataLabel)
        dataStackView.addArrangedSubview(dayLowDataLabel)
        dataStackView.addArrangedSubview(dayTurnoverDataLabel)
        dataStackView.addArrangedSubview(fundingRateDataLabel)
        dataStackView.addArrangedSubview(fundingCountdownDataLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            
            symbolNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            symbolNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin8),
            
            lastTradedPriceLabel.topAnchor.constraint(equalTo: symbolNameLabel.bottomAnchor, constant: Dimensions.Space.margin2),
            lastTradedPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin8),
            
            dayPercentageChangeLabel.topAnchor.constraint(equalTo: lastTradedPriceLabel.bottomAnchor, constant: Dimensions.Space.margin2),
            dayPercentageChangeLabel.leadingAnchor.constraint(equalTo: lastTradedPriceLabel.leadingAnchor),
            dayPercentageChangeLabel.trailingAnchor.constraint(equalTo: markPriceLabel.leadingAnchor),
            
            markPriceLabel.topAnchor.constraint(equalTo: dayPercentageChangeLabel.topAnchor),
            markPriceLabel.leadingAnchor.constraint(equalTo: lastTradedPriceLabel.centerXAnchor),
            markPriceLabel.trailingAnchor.constraint(equalTo: lastTradedPriceLabel.trailingAnchor),
            
            titleStackView.topAnchor.constraint(equalTo: symbolNameLabel.topAnchor),
            
            dataStackView.topAnchor.constraint(equalTo: titleStackView.topAnchor),
            dataStackView.leadingAnchor.constraint(equalTo: titleStackView.trailingAnchor, constant: Dimensions.Space.margin8),
            dataStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin8),
            dataStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin8)
        ])
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
}
