//
//  Bybit+SymbolInfoUpdate.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/25/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `SymbolInfoUpdate` object returned from the Bybit API
    struct SymbolInfoUpdate: Codable {

        var topic: Topic?
        var type: FormatType?
        var symbols: [Bybit.SymbolInfo?]?
        var metadata: Bybit.Metadata

        enum CodingKeys: String, CodingKey {
            case topic
            case type
            case data
            case update
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            topic = try values.decodeIfPresent(Topic.self, forKey: .topic)
            type = try values.decodeIfPresent(FormatType.self, forKey: .type)
            metadata = try Metadata(from: decoder)
            
            let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
            symbols = try dictionary.decodeIfPresent([Bybit.SymbolInfo].self, forKey: .update)
        }
        
        init(from data: Data) throws {
            let bookUpdate = try JSONDecoder().decode(Bybit.SymbolInfoUpdate.self, from: data)
            topic = bookUpdate.topic
            type = bookUpdate.type
            symbols = bookUpdate.symbols
            metadata = bookUpdate.metadata
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(topic, forKey: .topic)
            try container.encodeIfPresent(type, forKey: .type)
            try container.encodeIfPresent(symbols, forKey: .data)
            try metadata.encode(to: encoder)
        }
    }
}
