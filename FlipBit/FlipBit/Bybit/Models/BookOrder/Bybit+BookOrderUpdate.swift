//
//  Bybit+BookOrderUpdate.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `BookUpdate` object returned from the Bybit API
    struct BookUpdate: Codable {
        var topic: Topic?
        var type: FormatType?
        var delete: [BookOrder]?
        var update: [BookOrder]?
        var insert: [BookOrder]?
        var transactionTime: Int?
        var metadata: Metadata?

        enum CodingKeys: String, CodingKey {
            case topic
            case type
            case delete
            case update
            case insert
            case transactionTime = "transactTimeE6"
            case data
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            topic = try values.decodeIfPresent(Topic.self, forKey: .topic)
            type = try values.decodeIfPresent(FormatType.self, forKey: .type)
            metadata = try Metadata(from: decoder)

            let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
            delete = try dictionary.decodeIfPresent([BookOrder].self, forKey: .delete)
            update = try dictionary.decodeIfPresent([BookOrder].self, forKey: .update)
            insert = try dictionary.decodeIfPresent([BookOrder].self, forKey: .insert)
            transactionTime = try dictionary.decodeIfPresent(Int.self, forKey: .transactionTime)
        }
        
        init(from data: Data) throws {
            let bookUpdate = try JSONDecoder().decode(BookUpdate.self, from: data)
            topic = bookUpdate.topic
            type = bookUpdate.type
            delete = bookUpdate.delete
            update = bookUpdate.update
            insert = bookUpdate.insert
            transactionTime = bookUpdate.transactionTime
            metadata = bookUpdate.metadata
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(topic, forKey: .topic)
            try container.encodeIfPresent(type, forKey: .type)
            try container.encodeIfPresent(delete, forKey: .delete)
            try container.encodeIfPresent(update, forKey: .update)
            try container.encodeIfPresent(insert, forKey: .insert)
            try container.encodeIfPresent(transactionTime, forKey: .transactionTime)
            try metadata.encode(to: encoder)
        }
    }
}
