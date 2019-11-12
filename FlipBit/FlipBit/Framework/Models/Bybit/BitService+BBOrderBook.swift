//
//  BitService+BBOrderBook.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

struct BybitBookItem {
    let symbol: String
    let price: String
    let size: Int
    let side: String
}

extension BybitBookItem: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case symbol
        case price
        case size
        case side
    }

    init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try results.decode(String.self, forKey: .symbol)
        self.price = try results.decode(String.self, forKey: .price)
        self.size = try results.decode(Int.self, forKey: .size)
        self.side = try results.decode(String.self, forKey: .side)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(symbol, forKey: .symbol)
        try container.encode(price, forKey: .price)
        try container.encode(size, forKey: .size)
        try container.encode(side, forKey: .side)
    }
}

struct BybitOrderbook {

    let returnCode: Int
    let response: BybitOrderbook.Response
    let exitCode: String
    let exitInfo: String?
    let time: String
    let book: [BybitBookItem]

    enum Response: String, Decodable {
        case OK
        case failure
    }
}

extension BybitOrderbook: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case exit = "ext_code"
        case info = "ext_info"
        case response = "ret_msg"
        case returnCode = "ret_code"
        case result
        case time = "time_now"
    }

    internal init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.returnCode = try values.decode(Int.self, forKey: .returnCode)
        self.exitCode = try values.decode(String.self, forKey: .exit)
        self.exitInfo = try values.decodeIfPresent(String.self, forKey: .info)
        self.time = try values.decode(String.self, forKey: .time)
        self.response = try values.decode(Response.self, forKey: .response)

        self.book = try values.decode([BybitBookItem].self, forKey: .result)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(book, forKey: .result)
    }
}

