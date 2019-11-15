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

        /// The user's ID.
        let userID: Int
        
        /// The contract type.
        let symbol: BitService.BybitSymbol
        
        /// The side of the order.
        let side: BitService.BybitOrderSide

        /// The type of order.
        let orderType: BitService.BybitOrderType
        
        /// The price of the order. Required if you make a limit price order.
        let price: Double

        /// The quantity of the order.
        let quantity: Int

        /// The timing type of the order.
        let timeInForce: BitService.BybitOrderTimeInForce
        
        /// The status of the order.
        let orderStatus: BitService.BybitOrderStatus
        
        /// The remaining order quantity.
        let leaveQuantity: Int
        
        /// The remaining order value.
        let leaveValues: String
        
        /// The Accumulated execution quantity.
        let executionQuantity: Int
        
        /// The reason for rejection.
        let rejectReason: String
        
        /// The customized order ID, maximum length 36 characters.
        let orderLinkID: String
        
        /// The date the position was created.
        let dateCreated: String
        
        /// The date the position was last updated.
        let dateUpdated: String
        
        /// The order's ID.
        let orderID: String
    }
}

extension BitService.BybitOrder: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case userID = "user_ID"
        case symbol
        case side
        case orderType = "order_type"
        case price
        case quantity = "qty"
        case timeInForce = "time_in_force"
        case orderStatus = "order_status"
        case leaveQuantity = "leaves_qty"
        case leaveValues = "leaves_value"
        case executionQuantity = "cum_exec_qty"
        case rejectReason = "reject_reason"
        case orderLinkID = "order_link_id"
        case dateCreated = "created_at"
        case dateUpdated = "updated_at"
        case orderID = "order_id"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try results.decode(Int.self, forKey: .userID)
        self.symbol = try results.decode(BitService.BybitSymbol.self, forKey: .symbol)
        self.side = try results.decode(BitService.BybitOrderSide.self, forKey: .side)
        self.orderType = try results.decode(BitService.BybitOrderType.self, forKey: .orderType)
        self.price = try results.decode(Double.self, forKey: .price)
        self.quantity = try results.decode(Int.self, forKey: .quantity)
        self.timeInForce = try results.decode(BitService.BybitOrderTimeInForce.self, forKey: .timeInForce)
        self.orderStatus = try results.decode(BitService.BybitOrderStatus.self, forKey: .orderStatus)
        self.leaveQuantity = try results.decode(Int.self, forKey: .leaveQuantity)
        self.leaveValues = try results.decode(String.self, forKey: .leaveValues)
        self.executionQuantity = try results.decode(Int.self, forKey: .executionQuantity)
        self.rejectReason = try results.decode(String.self, forKey: .rejectReason)
        self.orderLinkID = try results.decode(String.self, forKey: .orderLinkID)
        self.dateCreated = try results.decode(String.self, forKey: .dateCreated)
        self.dateUpdated = try results.decode(String.self, forKey: .dateUpdated)
        self.orderID = try results.decode(String.self, forKey: .orderID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(side, forKey: .side)
        try container.encode(orderType, forKey: .orderType)
        try container.encode(price, forKey: .price)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(timeInForce, forKey: .timeInForce)
        try container.encode(orderStatus, forKey: .orderStatus)
        try container.encode(leaveQuantity, forKey: .leaveQuantity)
        try container.encode(leaveValues, forKey: .leaveValues)
        try container.encode(executionQuantity, forKey: .executionQuantity)
        try container.encode(rejectReason, forKey: .rejectReason)
        try container.encode(orderLinkID, forKey: .orderLinkID)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateUpdated, forKey: .dateUpdated)
        try container.encode(orderID, forKey: .orderID)
    }
}

public extension BitService {
    struct BybitOrderResponse {
        let returnCode: Int
        let response: BybitOrderResponse.Response
        let exitCode: String
        let exitInfo: String?
        let time: String
        let orderData: BitService.BybitOrder
        
        enum Response: String, Decodable {
            case OK
            case failure
        }
    }
}

extension BitService.BybitOrderResponse: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case exit = "ext_code"
        case info = "ext_info"
        case response = "ret_msg"
        case returnCode = "ret_code"
        case result
        case time = "time_now"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.returnCode = try values.decode(Int.self, forKey: .returnCode)
        self.exitCode = try values.decode(String.self, forKey: .exit)
        self.exitInfo = try values.decodeIfPresent(String.self, forKey: .info)
        self.time = try values.decode(String.self, forKey: .time)
        self.response = try values.decode(Response.self, forKey: .response)
    
        self.orderData = try values.decode(BitService.BybitOrder.self, forKey: .result)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderData, forKey: .result)
    }
}
