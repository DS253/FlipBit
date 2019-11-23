//
//  BybitSocketResponse.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/22/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

struct BybitSocketResponse: Codable {
    var success: Bool?
    var message: String?
    var connectionID: String?
    var operation: String?
    var arguments: [String]?

    enum CodingKeys: String, CodingKey {
        case success
        case message = "ret_msg"
        case connection = "conn_id"
        case operation = "op"
        case arguments = "args"
        case request
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        connectionID = try values.decodeIfPresent(String.self, forKey: .connection)

        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .request)

        operation = try dictionary.decodeIfPresent(String.self, forKey: .operation)
        arguments = try dictionary.decodeIfPresent([String].self, forKey: .arguments)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(success, forKey: .success)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(connectionID, forKey: .connection)
        try container.encodeIfPresent(operation, forKey: .operation)
        try container.encodeIfPresent(arguments, forKey: .arguments)
    }
}
