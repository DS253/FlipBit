//
//  BybitOrderBook.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/19/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

struct BookOrder: Codable {
    var price: String?
    var symbol: String?
    var id: Int?
    var side: String?
    var size: Int?

    enum CodingKeys: String, CodingKey {
        case price
        case symbol
        case id
        case side
        case size
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        side = try values.decodeIfPresent(String.self, forKey: .side)
        size = try values.decodeIfPresent(Int.self, forKey: .size)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(symbol, forKey: .symbol)
        try container.encodeIfPresent(symbol, forKey: .symbol)
        try container.encodeIfPresent(side, forKey: .side)
        try container.encodeIfPresent(size, forKey: .size)
    }
}

struct BookOrderSnapshot: Codable {
    var topic: String?
    var type: String?
    var book: [BookOrder]?
    var crossSequence: Int?
    var timestamp: Int?

    enum CodingKeys: String, CodingKey {
        case topic
        case type
        case cross = "cross_seq"
        case timestamp = "timestamp_e6"
        case book = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        book = try values.decodeIfPresent([BookOrder].self, forKey: .book)
        topic = try values.decodeIfPresent(String.self, forKey: .topic)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        crossSequence = try values.decodeIfPresent(Int.self, forKey: .cross)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(book, forKey: .book)
        try container.encodeIfPresent(topic, forKey: .topic)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(crossSequence, forKey: .cross)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
    }
}

struct BookUpdate: Codable {
    var topic: String?
    var type: String?
    var delete: [BookOrder]?
    var update: [BookOrder]?
    var insert: [BookOrder]?
    var transactionTime: Int?
    var crossSequence: Int?
    var timestamp: Int?

    enum CodingKeys: String, CodingKey {
        case topic
        case type
        case delete
        case update
        case insert
        case transactionTime = "transactTimeE6"
        case data
        case cross = "cross_seq"
        case timestamp = "timestamp_e6"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        topic = try values.decodeIfPresent(String.self, forKey: .topic)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        crossSequence = try values.decodeIfPresent(Int.self, forKey: .cross)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)

        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        delete = try dictionary.decodeIfPresent([BookOrder].self, forKey: .delete)
        update = try dictionary.decodeIfPresent([BookOrder].self, forKey: .update)
        insert = try dictionary.decodeIfPresent([BookOrder].self, forKey: .insert)
        transactionTime = try dictionary.decodeIfPresent(Int.self, forKey: .transactionTime)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(topic, forKey: .topic)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(crossSequence, forKey: .cross)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)

        try container.encodeIfPresent(delete, forKey: .delete)
        try container.encodeIfPresent(update, forKey: .update)
        try container.encodeIfPresent(insert, forKey: .insert)
        try container.encodeIfPresent(transactionTime, forKey: .transactionTime)
    }

}
