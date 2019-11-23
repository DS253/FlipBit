//
//  Bybit+BookOrder.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `BookOrder` object returned from the Bybit API
    struct BookOrder: Codable {        
        var price: String?
        var symbol: Symbol?
        var id: Int?
        var side: Side?
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
            symbol = try values.decodeIfPresent(Symbol.self, forKey: .symbol)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            side = try values.decodeIfPresent(Side.self, forKey: .side)
            size = try values.decodeIfPresent(Int.self, forKey: .size)
        }
        
        init(from data: Data) throws {
            let order = try JSONDecoder().decode(BookOrder.self, from: data)
            price = order.price
            symbol = order.symbol
            id = order.id
            side = order.side
            size = order.size
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(price, forKey: .price)
            try container.encodeIfPresent(symbol, forKey: .symbol)
            try container.encodeIfPresent(id, forKey: .id)
            try container.encodeIfPresent(side, forKey: .side)
            try container.encodeIfPresent(size, forKey: .size)
        }
    }
}
