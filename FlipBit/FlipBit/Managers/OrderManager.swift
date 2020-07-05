//
//  OrderManager.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/26/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import Foundation

class OrderManager {
    
    private var price: Double = 0.0
    private var quantity: Double = 0.0
    private var leverage: Double = 0.0
    private var side: Bybit.Side
    
    /// The amount of collateral required to open a position for leverage trading.
    private lazy var initialMargin: Double = {
        print("quantity: \(quantity)" )
        return quantity / (price * leverage)
    }()
    
    /// The fee required to open a position.
    private lazy var openFee: Double = {
        return (quantity / price) * fee()
    }()
    
    /// The fee required to close a position.
    private lazy var closeFee: Double = {
        return (quantity / bankruptcyPrice) * fee()
    }()
    
    /// The price level that indicates you have lost all your initial margin.
    /// Used to calculate the closing fee.
    private var bankruptcyPrice: Double {
        if side == .Buy {
            return price * (leverage / (leverage + 1.0))
        }
        return price * (leverage / (leverage - 1.0))
    }
    
    /// The value of the order factoring in leverage.
    lazy var orderValue: Double = {
        return initialMargin * leverage
    }()
    
    init(price: Double?, quantity: Double?, leverage: Double?, tradeType: Bybit.Side) {
        self.price = price ?? 0.0
        self.quantity = quantity ?? 0.0
        self.leverage = leverage ?? 0.0
        self.side = tradeType
    }
    
    /// Determines the rate used to calculate  the open and closing fees.
    private func fee() -> Double {
        guard
            let stringPrice = symbolObserver.symbolInfo?.lastPrice
        else { return 0.0 }
        
        let doublePrice = Double(stringPrice)
        /// If the order is a Buy/Long, an order price less than the most recent transaction price will have a Taker Fee.
        /// An order greater than the most recent price will have a Maker Fee.
        if side == .Buy {
            if price <= doublePrice { return Bybit.Fee.Taker.rawValue }
            return Bybit.Fee.Maker.rawValue
        }
        
        /// If the order is a Sell/Short, an order price more than the most recent transaction price will have a Taker Fee.
        /// An order less than the most recent price will have a Maker Fee.
        if price >= doublePrice { return Bybit.Fee.Taker.rawValue }
        return Bybit.Fee.Maker.rawValue
    }
    
    func update(quantity: String) {
        print(quantity)
        guard let newQuantity = Double(quantity) else { return }
        self.quantity = newQuantity
        print(self.quantity)
    }
    
    func provideEstimatedOrderValue() -> Double {
        return initialMargin + openFee + closeFee
    }
}
