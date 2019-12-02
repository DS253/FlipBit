//
//  Bybit+TradeEvent.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/1/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `TradeEvent` object returned from the Bybit API
    struct TradeEvent: Codable {
        
        /// The symbol.
        var symbol: Bybit.Symbol?
        
        /// Indicates if a buy or sell triggered the trade.
        var side: Side?
        
        /// The number of contracts purchased/sold in the trade.
        var size: Int?
        
        /// The price at which the trade occurred.
        var price: Double?
        
        /// The direction price has moved.
        var tickDirection: Bybit.TickDirection?
        
        /// Uninque ID assigned to a trade.
        var tradeID: String?
        
        /// The time of the trade occurred.
        var timestamp: String?
        
        var crossSequence: Int?

        enum CodingKeys: String, CodingKey {
            case symbol
            case side
            case size
            case price
            case tick = "tick_direction"
            case tradeID = "trade_id"
            case timestamp = "timestamp"
            case cross = "cross_seq"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            symbol = try values.decodeIfPresent(Bybit.Symbol.self, forKey: .symbol)
            side = try values.decodeIfPresent(Side.self, forKey: .side)
            size = try values.decodeIfPresent(Int.self, forKey: .size)
            price = try values.decodeIfPresent(Double.self, forKey: .price)
            tickDirection = try values.decodeIfPresent(TickDirection.self, forKey: .tick)
            tradeID = try values.decodeIfPresent(String.self, forKey: .tradeID)
            timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
            crossSequence = try values.decodeIfPresent(Int.self, forKey: .cross)
        }
        
        init(from data: Data) throws {
            let trade = try JSONDecoder().decode(TradeEvent.self, from: data)
            symbol = trade.symbol
            side = trade.side
            size = trade.size
            price = trade.price
            tickDirection = trade.tickDirection
            tradeID = trade.tradeID
            timestamp = trade.timestamp
            crossSequence = trade.crossSequence
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(symbol, forKey: .symbol)
            try container.encodeIfPresent(side, forKey: .side)
            try container.encodeIfPresent(size, forKey: .size)
            try container.encodeIfPresent(price, forKey: .price)
            try container.encodeIfPresent(tickDirection, forKey: .tick)
            try container.encodeIfPresent(tradeID, forKey: .tradeID)
            try container.encodeIfPresent(timestamp, forKey: .timestamp)
            try container.encodeIfPresent(crossSequence, forKey: .cross)
        }
    }
}
