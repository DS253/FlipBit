//
//  Bybit+Metadata.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `Metadata` object returned with every response from the Bybit API
    struct Metadata: Codable {
        var crossSequence: Int?
        var timestamp: Int?
        
        enum CodingKeys: String, CodingKey {
            case cross = "cross_seq"
            case timestamp = "timestamp_e6"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            crossSequence = try values.decodeIfPresent(Int.self, forKey: .cross)
            timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(crossSequence, forKey: .cross)
            try container.encodeIfPresent(timestamp, forKey: .timestamp)
        }
    }
}
