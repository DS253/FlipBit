//
//  Bybit+SymbolInfoSnapshot.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/25/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `SymbolInfoSnapshot` object returned from the Bybit API
    struct SymbolInfoSnapshot: Codable {
        var topic: Topic?
        var type: FormatType?
        var symbol: [BookOrder]?
        var metadata: Metadata?
        
        
        enum CodingKeys: String, CodingKey {
            case topic
            case type
            case symbol = "data"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            symbol = try values.decodeIfPresent([BookOrder].self, forKey: .symbol)
            topic = try values.decodeIfPresent(Topic.self, forKey: .topic)
            type = try values.decodeIfPresent(FormatType.self, forKey: .type)
            metadata = try Metadata(from: decoder)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(symbol, forKey: .symbol)
            try container.encodeIfPresent(topic, forKey: .topic)
            try container.encodeIfPresent(type, forKey: .type)
            try metadata.encode(to: encoder)
        }
    }
}
