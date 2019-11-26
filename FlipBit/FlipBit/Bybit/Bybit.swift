//
//  Bybit.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

public struct Bybit {
    
}

public extension Bybit {
    
    enum BookOrderResponseResult {
        case Snapshot
        case Update
        case Delete
        case Insert
        case SocketResponse
        case DecodingFailure
        case UnknownResponse
    }
    
    enum SymbolInfoResponseResult {
        case Snapshot
        case Update
        case SocketResponse
        case DecodingFailure
        case UnknownResponse
    }
    
    enum FormatType: String, Codable {
        case Snapshot = "snapshot"
        case Update = "delta"
    }
    
    enum Side: String, Codable {
        case Buy
        case Sell
    }
    
    enum Symbol: String, Codable {
        case BTC = "BTCUSD"
        case ETH = "ETHUSD"
        case EOS = "EOSUSD"
        case XRP = "XRPUSD"
    }

    /// The most recent directional change in price.
    enum TickDirection: String, Codable {
        case PlusTick
        case ZeroPlusTick
        case MinusTick
        case ZeroMinusTick
    }

    enum Topic: String, Codable {
        case OrderBook = "orderBookL2_25.BTCUSD"
    }
}
