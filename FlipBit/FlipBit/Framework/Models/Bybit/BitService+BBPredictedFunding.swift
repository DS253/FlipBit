//
//  BitService+BBPredictedFunding.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

struct BybitPredictedFunding {
    let returnCode: Int
    let response: BybitPredictedFunding.Response
    let exitCode: String
    let exitInfo: String?
    let time: String
    let fundingRate: Double
    let fundingFee: Double
    
    enum Response: String, Decodable {
        case ok
        case failure
    }
}

extension BybitPredictedFunding: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case exit = "ext_code"
        case info = "ext_info"
        case response = "ret_msg"
        case returnCode = "ret_code"
        case result
        case time = "time_now"
        case fundingRate = "predicted_funding_rate"
        case fundingFee = "predicted_funding_fee"
    }
    
    internal init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.returnCode = try values.decode(Int.self, forKey: .returnCode)
        self.exitCode = try values.decode(String.self, forKey: .exit)
        self.exitInfo = try values.decodeIfPresent(String.self, forKey: .info)
        self.time = try values.decode(String.self, forKey: .time)
        self.response = try values.decode(Response.self, forKey: .response)
        
        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        
        self.fundingRate = try dictionary.decode(Double.self, forKey: .fundingRate)
        self.fundingFee = try dictionary.decode(Double.self, forKey: .fundingFee)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fundingFee, forKey: .fundingFee)
        try container.encode(fundingRate, forKey: .fundingRate)
    }
}

