//
//  BitService+BBTradeRecord.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    struct BybitTradeRecords {
        
        /// An array of TradeEvents.
        let records: [BitService.BybitTradeEvent]
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitTradeRecords: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
        case tradeList = "trade_list"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        
        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.records = try dictionary.decode([BitService.BybitTradeEvent].self, forKey: .tradeList)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(records, forKey: .tradeList)
    }
}

public extension BitService {
    /// A type that represents a trading event.
    struct BybitTradeEvent {
        
        /// The size of the trade at the time of it's closing.
        let closedSize: Int
        
        /// The Crossed Leverage?
        let crossSeq: Int
        
        /// The execution fee of the trade.
        let executionFee: String
        
        /// The unique execution ID.
        let executionID: String
        
        /// The execution price.
        let executionPrice: String
        
        /// The execution quantity.
        let executionQuantity: Int
        
        /// The time the trade was executed.
        let executionTime: String
        
        /// The type of transaction.
        let executionType: BitService.BybitExecutionType
        
        /// The value of the executed trade.
        let executionValue: String
        
        /// The fee rate for the executed trade.
        let feeRate: String
        
        /// The liquidity movement.
        let liquidityIndex: BitService.BybitLiquidity
        
        /// The remaining order quantity.
        let leaveQuantity: Int
        
        /// The number of fills for the order.
        let numberOfFills: Int
        
        /// The order ID.
        let orderID: String
        
        /// The order price.
        let orderPrice: String
        
        /// The order quantity.
        let orderQuantity: Int
        
        /// The type of order.
        let orderType: BitService.BybitOrderType
        
        /// The side of the order.
        let side: BitService.BybitOrderSide
        
        /// The symbol of the order.
        let symbol: BitService.BybitSymbol
        
        /// The user's ID.
        let userID: Int
    }
}

extension BitService.BybitTradeEvent: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case closedSize = "closed_size"
        case crossSeq = "cross_seq"
        case executionFee = "exec_fee"
        case executionID = "exec_id"
        case executionPrice = "exec_price"
        case executionQuantity = "exec_qty"
        case executionTime = "exec_time"
        case executionType = "exec_type"
        case executionValue = "exec_value"
        case feeRate = "fee_rate"
        case liquidityIndex = "last_liquidity_ind"
        case leaveQuantity = "leaves_qty"
        case numberOfFills = "nth_fill"
        case orderID = "order_id"
        case orderPrice = "order_price"
        case orderQuantity = "order_qty"
        case orderType = "order_type"
        case side
        case symbol
        case userID = "user_id"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.closedSize = try results.decode(Int.self, forKey: .closedSize)
        self.crossSeq = try results.decode(Int.self, forKey: .crossSeq)
        self.executionFee = try results.decode(String.self, forKey: .executionFee)
        self.executionID = try results.decode(String.self, forKey: .executionID)
        self.executionPrice = try results.decode(String.self, forKey: .executionPrice)
        self.executionQuantity = try results.decode(Int.self, forKey: .executionQuantity)
        self.executionTime = try results.decode(String.self, forKey: .executionTime)
        self.executionType = try results.decode(BitService.BybitExecutionType.self, forKey: .executionType)
        self.executionValue = try results.decode(String.self, forKey: .executionValue)
        self.feeRate = try results.decode(String.self, forKey: .feeRate)
        self.liquidityIndex = try results.decode(BitService.BybitLiquidity.self, forKey: .liquidityIndex)
        self.leaveQuantity = try results.decode(Int.self, forKey: .leaveQuantity)
        self.numberOfFills = try results.decode(Int.self, forKey: .numberOfFills)
        self.orderID = try results.decode(String.self, forKey: .orderID)
        self.orderPrice = try results.decode(String.self, forKey: .orderPrice)
        self.orderQuantity = try results.decode(Int.self, forKey: .orderQuantity)
        self.orderType = try results.decode(BitService.BybitOrderType.self, forKey: .orderType)
        self.side = try results.decode(BitService.BybitOrderSide.self, forKey: .side)
        self.symbol = try results.decode(BitService.BybitSymbol.self, forKey: .symbol)
        self.userID = try results.decode(Int.self, forKey: .userID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(closedSize, forKey: .closedSize)
        try container.encode(crossSeq, forKey: .crossSeq)
        try container.encode(executionFee, forKey: .executionFee)
        try container.encode(executionID, forKey: .executionID)
        try container.encode(executionPrice, forKey: .executionPrice)
        try container.encode(executionQuantity, forKey: .executionQuantity)
        try container.encode(executionTime, forKey: .executionTime)
        try container.encode(executionType, forKey: .executionType)
        try container.encode(executionValue, forKey: .executionValue)
        try container.encode(feeRate, forKey: .feeRate)
        try container.encode(liquidityIndex, forKey: .liquidityIndex)
        try container.encode(leaveQuantity, forKey: .leaveQuantity)
        try container.encode(numberOfFills, forKey: .numberOfFills)
        try container.encode(orderID, forKey: .orderID)
        try container.encode(orderPrice, forKey: .orderPrice)
        try container.encode(orderQuantity, forKey: .orderQuantity)
        try container.encode(orderType, forKey: .orderType)
        try container.encode(side, forKey: .side)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(userID, forKey: .userID)
    }
}
