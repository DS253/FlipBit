//
//  BitService+BBCancelOrder.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

public extension BitService {
    /// A type that represent a cancelled Bybit order.
    struct BybitCancelledOrder {
        
        /// The details of the cancelled order.
        let details: BitService.BybitOrder
        
        /// The time of the last transaction.
        let lastExecutionTime: String?
        
        /// The price of the last transaction.
        let lastExecutionPrice: Double?
        
        /// Accumulated execution value.
        let totalExecutionValue: Double?
        
        /// Accumulated execution fee.
        let totalExecutionFee: Double?
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitCancelledOrder: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case lastExecTime = "last_exec_time"
        case lastExecPrice = "last_exec_price"
        case totalExecValue = "cum_exec_value"
        case totalExecFee = "cum_exec_fee"
        case result
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        self.details = try results.decode(BitService.BybitOrder.self, forKey: .result)
        self.lastExecutionTime = try results.decodeIfPresent(String.self, forKey: .lastExecTime)
        self.lastExecutionPrice = try results.decodeIfPresent(Double.self, forKey: .lastExecPrice)
        self.totalExecutionValue = try results.decodeIfPresent(Double.self, forKey: .totalExecValue)
        self.totalExecutionFee = try results.decodeIfPresent(Double.self, forKey: .totalExecFee)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(lastExecutionTime, forKey: .lastExecTime)
        try container.encodeIfPresent(lastExecutionPrice, forKey: .lastExecPrice)
        try container.encodeIfPresent(totalExecutionValue, forKey: .totalExecValue)
        try container.encodeIfPresent(totalExecutionFee, forKey: .totalExecFee)
    }
}
