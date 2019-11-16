//
//  BitService+BBPreviousFundingRate.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/13/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    struct BybitPreviousFundingRate {
        
        /// Details of the previous funding rate.
        let rateData: BitService.BybitPreviousFundingRateData
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitPreviousFundingRate: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        self.rateData = try values.decode(BitService.BybitPreviousFundingRateData.self, forKey: .result)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rateData, forKey: .result)
    }
}

public extension BitService {
    struct BybitPreviousFundingRateData {
        
        /// The symbol of the order in which the fee occurred.
        let symbol: BitService.BybitSymbol
        
        /// The funding rate. When the funding rate is positive, longs pay shorts. When it is negative, shorts pay longs.
        let fundingRate: String
        
        /// The date of the funding rate generation.
        let fundingRateDate: Int
    }
}

extension BitService.BybitPreviousFundingRateData: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case symbol
        case fundingRate = "funding_rate"
        case fundingRateDate = "funding_rate_timestamp"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try results.decode(BitService.BybitSymbol.self, forKey: .symbol)
        self.fundingRate = try results.decode(String.self, forKey: .fundingRate)
        self.fundingRateDate = try results.decode(Int.self, forKey: .fundingRateDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(fundingRate, forKey: .fundingRate)
        try container.encode(fundingRateDate, forKey: .fundingRateDate)
    }
}
