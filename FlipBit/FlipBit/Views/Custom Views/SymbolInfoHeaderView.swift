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
    
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var symbolNameLabel: UILabel = {
        UILabel(font: UIFont.title2.bold, textColor: UIColor.Bybit.titleGray)
    }()
    
    private lazy var lastTradedPriceLabel: UILabel = {
        UILabel(font: UIFont.title3.bold, textColor: UIColor.Bybit.orderbookGreen)
    }()
    
    private lazy var markPriceLabel: UILabel = {
        UILabel(font: UIFont.footnote.bold, textColor: UIColor.Bybit.markPriceOrange)
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbolInfo(notification:)), name: .symbolObserverUpdate, object: nil)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(symbolNameLabel)
        addSubview(lastTradedPriceLabel)
        addSubview(dataStackView)
        
        dataStackView.addArrangedSubview(markPriceLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            
            dataStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dataStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dataStackView.leadingAnchor.constraint(equalTo: centerXAnchor),
            dataStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            symbolNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            symbolNameLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            symbolNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolNameLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            
            lastTradedPriceLabel.topAnchor.constraint(equalTo: centerYAnchor),
            lastTradedPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            lastTradedPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            lastTradedPriceLabel.trailingAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configureView() {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let symbolName = newInfo.symbol {
            symbolNameLabel.text = symbolName.rawValue
        }
        if let lastPrice = newInfo.lastPrice, let stringPrice = lastPrice.formatBybitPriceString() {
            
            lastTradedPriceLabel.text = stringPrice
        }
        if let mark = newInfo.markPrice {
            markPriceLabel.text = String(mark)
        }
    }
        
    @objc func updateSymbolInfo(notification: NSNotification) {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let symbolName = newInfo.symbol {
            symbolNameLabel.text = symbolName.rawValue
        }
        if let lastPrice = newInfo.lastPrice?.formatBybitPriceString() {
            lastTradedPriceLabel.text = lastPrice
        }
        
        if let mark = newInfo.markPrice?.formatBybitPriceString() {
            markPriceLabel.text = String(mark)
        }
    }
}
