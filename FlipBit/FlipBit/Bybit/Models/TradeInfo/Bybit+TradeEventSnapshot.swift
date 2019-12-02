//
//  Bybit+TradeEventSnapshot.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/1/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `TradeEventSnapshot` object returned from the Bybit API.
    struct TradeEventSnapshot: Codable {
        
        /// The Bybit socket topic.
        var topic: Topic?
        
        /// An array of TradeEvents.
        var trades: [TradeEvent]?
        
        enum CodingKeys: String, CodingKey {
            case topic
            case trades = "data"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            topic = try values.decodeIfPresent(Topic.self, forKey: .topic)
            trades = try values.decodeIfPresent([TradeEvent].self, forKey: .trades)
        }

        init(from data: Data) throws {
            let snapshot = try JSONDecoder().decode(TradeEventSnapshot.self, from: data)
            topic = snapshot.topic
            trades = snapshot.trades
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(topic, forKey: .topic)
            try container.encodeIfPresent(trades, forKey: .trades)
        }
    }
}
