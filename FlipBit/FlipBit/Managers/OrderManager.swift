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

    init(price: Double?, quantity: Double?, leverage: Double?, tradeType: Bybit.Type) {
        self.price = price ?? 0.0
        self.quantity = quantity ?? 0.0
        self.leverage = leverage ?? 0.0
    }
    
    func initialMargin() -> Double {
        return quantity / (price * leverage)
    }
}
