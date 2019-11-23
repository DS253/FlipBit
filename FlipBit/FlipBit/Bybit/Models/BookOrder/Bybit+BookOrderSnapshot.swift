//
//  Bybit+BookOrderSnapshot.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
/// A type that represent a `BookOrderSnapshot` object returned from the Bybit API
    struct BookOrderSnapshot: Codable {
        var topic: Topic?
        var type: FormatType?
        var book: [BookOrder]?
        var metadata: Metadata?

        enum CodingKeys: String, CodingKey {
            case topic
            case type
            case book = "data"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            book = try values.decodeIfPresent([BookOrder].self, forKey: .book)
            topic = try values.decodeIfPresent(Topic.self, forKey: .topic)
            type = try values.decodeIfPresent(FormatType.self, forKey: .type)
            metadata = try Metadata(from: decoder)
        }
        
        init(from data: Data) throws {
            let snapshot = try JSONDecoder().decode(BookOrderSnapshot.self, from: data)
            topic = snapshot.topic
            type = snapshot.type
            book = snapshot.book
            metadata = snapshot.metadata
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(book, forKey: .book)
            try container.encodeIfPresent(topic, forKey: .topic)
            try container.encodeIfPresent(type, forKey: .type)
            try metadata.encode(to: encoder)
        } 
    }
}
