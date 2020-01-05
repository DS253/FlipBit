//
//  Bybit.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import UIKit

public struct Bybit {
    
    var tickColor: UIColor = {
        switch symbolObserver.symbolInfo?.tickDirection {
        case .PlusTick, .ZeroPlusTick:
            return UIColor.Bybit.orderbookGreen
        case .MinusTick, .ZeroMinusTick:
            return UIColor.Bybit.orderbookRed
        default:
            return UIColor.Bybit.orderbookGreen
        }
    }()
    
    var percentageDifferenceColor: UIColor? = {
        if let info = symbolObserver.symbolInfo {
            if info.prevPcnt24H ?? "0" < "0" { return UIColor.Bybit.orderbookRed }
            return UIColor.Bybit.orderbookGreen
        } else { return nil }
    }()
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
    
    enum PositionResponseResult {
        case PositionList
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
    
    enum TradeEventResponseResult {
        case Snapshot
        case SocketResponse
        case UnknownResponse
        case DecodingFailure
    }
    
    enum FormatType: String, Codable {
        case Snapshot = "snapshot"
        case Update = "delta"
    }
    
    enum Side: String, Codable {
        case Buy
        case Sell
        case None
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
        case SymbolInfo = "instrument_info.100ms.BTCUSD"
        case TradeInfo = "trade.BTCUSD"
    }
}
