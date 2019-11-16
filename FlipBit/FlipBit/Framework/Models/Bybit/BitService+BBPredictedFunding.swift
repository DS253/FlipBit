//
//  BitService+BBPredictedFunding.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {

    struct BybitPredictedFunding {
        
        /// The predicted funding rate. When the rate is positive, longs pay shorts. When negative, shorts pay longs.
        let fundingRate: Double
        
        /// The funding fee.
        let fundingFee: Double
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitPredictedFunding: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
        case fundingRate = "predicted_funding_rate"
        case fundingFee = "predicted_funding_fee"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        
        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.fundingRate = try dictionary.decode(Double.self, forKey: .fundingRate)
        self.fundingFee = try dictionary.decode(Double.self, forKey: .fundingFee)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fundingFee, forKey: .fundingFee)
        try container.encode(fundingRate, forKey: .fundingRate)
    }
}
