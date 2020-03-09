//
//  BitService+BBActiveOrder.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

public extension BitService {
    struct BybitActiveOrderList {
        
        /// An array of active orders.
        let activeOrders: [BitService.BybitActiveOrder]?
        
        /// The current page of displayed active orders.
        let currentPage: Int?
        
        /// The total number of pages.
        let totalPages: Int?
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitActiveOrderList: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
        case data
        case currentPage = "current_page"
        case total
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        self.currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
        self.totalPages = try values.decodeIfPresent(Int.self, forKey: .total)
        
        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.activeOrders = try dictionary.decode([BitService.BybitActiveOrder].self, forKey: .data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activeOrders, forKey: .data)
        try container.encodeIfPresent(currentPage, forKey: .currentPage)
        try container.encodeIfPresent(totalPages, forKey: .total)
    }
}

public extension BitService {
    /// A type that represent an active Bybit order.
    struct BybitActiveOrder {
        
        /// The order's main details.
        let details: BitService.BybitOrder
        
        /// The time of the last transaction.
        let lastExecutionTime: String
        
        /// The price of the last transaction.
        let lastExecutionPrice: Double
        
        /// Accumulated execution value.
        let totalExecutionValue: Double
        
        /// Accumulated execution fee.
        let totalExecutionFee: Double
    }
}

extension BitService.BybitActiveOrder: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case lastExecTime = "last_exec_time"
        case lastExecPrice = "last_exec_price"
        case totalExecValue = "cum_exec_value"
        case totalExecFee = "cum_exec_fee"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.details = try BitService.BybitOrder(from: decoder)
        self.lastExecutionTime = try results.decode(String.self, forKey: .lastExecTime)
        self.lastExecutionPrice = try results.decode(Double.self, forKey: .lastExecPrice)
        self.totalExecutionValue = try results.decode(Double.self, forKey: .totalExecValue)
        self.totalExecutionFee = try results.decode(Double.self, forKey: .totalExecFee)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastExecutionTime, forKey: .lastExecTime)
        try container.encode(lastExecutionPrice, forKey: .lastExecPrice)
        try container.encode(totalExecutionValue, forKey: .totalExecValue)
        try container.encode(totalExecutionFee, forKey: .totalExecFee)
    }
}
