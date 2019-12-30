//
//  Order.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

enum OrderType: String, Codable {
    case Limit
    case Market
    case Conditional
}

class Order {
    var type: OrderType
    var side: Bybit.Side
    var price: String
    var quantity: String
    var stopLoss: String?
    var takeProfit: String?
    
    init(type: OrderType = .Limit, side: Bybit.Side, price: String, quantity: String, stopLoss: String? = nil, takeProfit: String? = nil) {
        self.type = type
        self.side = side
        self.price = price
        self.quantity = quantity
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
    }
}
