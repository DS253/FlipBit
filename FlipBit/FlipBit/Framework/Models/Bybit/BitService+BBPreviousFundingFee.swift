//
//  BitService+BBPreviousFundingFee.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    struct BybitPreviousFundingFee {
        
        /// Details of the last funding fee.
        let feeData: BitService.BybitPreviousFundingFeeData?
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitPreviousFundingFee: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        self.feeData = try values.decodeIfPresent(BitService.BybitPreviousFundingFeeData.self, forKey: .result)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(feeData, forKey: .result)
    }
}

public extension BitService {
    struct BybitPreviousFundingFeeData {
        
        /// The symbol of the order in which the fee occurred.
        let symbol: Bybit.Symbol
        
        /// The side of the order in which the fee occurred.
        let side: BybitOrderSide
        
        /// The position size of the order in which the fee occurred.
        let size: Int
        
        /// The funding rate at the time of the fee.
        let fundingRate: Double
        
        /// The funding fee amount.
        let fee: Double
        
        /// The date of the fee.
        let timeOfSettlement: Double
    }
}

extension BitService.BybitPreviousFundingFeeData: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case symbol
        case side
        case size
        case fundingRate = "funding_rate"
        case fee = "exec_fee"
        case timeOfSettlement = "exec_timestamp"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try results.decode(Bybit.Symbol.self, forKey: .symbol)
        self.size = try results.decode(Int.self, forKey: .size)
        self.side = try results.decode(BitService.BybitOrderSide.self, forKey: .side)
        self.fundingRate = try results.decode(Double.self, forKey: .fundingRate)
        self.fee = try results.decode(Double.self, forKey: .fee)
        self.timeOfSettlement = try results.decode(Double.self, forKey: .timeOfSettlement)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(size, forKey: .size)
        try container.encode(side, forKey: .side)
        try container.encode(fundingRate, forKey: .fundingRate)
        try container.encode(fee, forKey: .fee)
        try container.encode(timeOfSettlement, forKey: .timeOfSettlement)
    }
}
