//
//  BitService+BBOrder.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/14/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    /// A type that represents the API Key information for the Bybit account.
    struct BybitOrder {

        /// The side of the order.
        let side: BitService.BybitOrderSide

        /// The contract type.
        let symbol: BitService.BybitSymbol

        /// The type of order.
        let orderType: BitService.BybitOrderType

        /// The quantity of the order.
        let quantity: Int

        /// The price of the order. Required if you make a limit price order.
        let price: Double

        /// The timing type of the order.
        let timeInForce: BitService.BybitOrderTimeInForce

        /// The take profit price of the order.
        let takeProfitPrice: Double

        /// The stop loss price of the order.
        let stopLossPrice: Double

        /// Reduce-only for the order.
        let reduceOnly: Bool

        /// Close on Trigger for the order.
        let closeOnTrigger: Bool

        /// The customized order ID, maximum length 36 characters.
        let orderLinkID: String

        let response: BybitOrder.Response

        enum Response: String, Decodable {
            case ok
            case failure
        }
    }
}

extension BitService.BybitOrder: Model {
//    /// List of top level coding keys.
//    private enum CodingKeys: String, CodingKey {
//        case exit = "ext_code"
//        case info = "ext_info"
//        case response = "ret_msg"
//        case returnCode = "ret_code"
//        case result
//        case time = "time_now"
//    }
//
//    private enum ResultKeys: String, CodingKey {
//        case apiKey = "api_key"
//        case userID = "user_id"
//        case ipAddresses = "ips"
//        case note
//        case permissions
//        case timeCreated = "created_at"
//        case isReadOnly = "read_only"
//    }
//
//    public init(from decoder: Decoder) throws {
//        let results = try decoder.container(keyedBy: CodingKeys.self)
//        self.response = try results.decode(Response.self, forKey: .response)
//
//        var array = try results.nestedUnkeyedContainer(forKey: .result)
//        let data = try array.nestedContainer(keyedBy: ResultKeys.self)
//
//        self.apiKey = try data.decode(String.self, forKey: .apiKey)
//        self.userID = try data.decode(Int.self, forKey: .userID)
//        self.ipAddresses = try data.decode(Array.self, forKey: .ipAddresses)
//        self.note = try data.decode(String.self, forKey: .note)
//        self.permissions = try data.decode(Array.self, forKey: .permissions)
//        self.timeCreated = try data.decode(String.self, forKey: .timeCreated)
//        self.isReadOnly = try data.decode(Bool.self, forKey: .isReadOnly)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: ResultKeys.self)
//
//        try container.encode(apiKey, forKey: .apiKey)
//        try container.encode(userID, forKey: .userID)
//        try container.encode(ipAddresses, forKey: .ipAddresses)
//        try container.encode(note, forKey: .note)
//        try container.encode(permissions, forKey: .permissions)
//        try container.encode(timeCreated, forKey: .timeCreated)
//        try container.encode(isReadOnly, forKey: .isReadOnly)
//    }
}
