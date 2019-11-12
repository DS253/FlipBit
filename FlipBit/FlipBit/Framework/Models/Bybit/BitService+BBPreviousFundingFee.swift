//
//  BitService+BBPreviousFundingFee.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

struct BybitPreviousFundingFee {
    
    let returnCode: Int
    let response: BybitPreviousFundingFee.Response
    let exitCode: String
    let exitInfo: String?
    let time: String
    
    let symbol: String
    let side: String
    let size: Int
    let fundingRate: Double
    let fee: Double
    let timeOfSettlement: Double
    
    enum Response: String, Decodable {
        case ok
        case failure
    }
}

extension BybitPreviousFundingFee: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case exit = "ext_code"
        case info = "ext_info"
        case response = "ret_msg"
        case returnCode = "ret_code"
        case result
        case time = "time_now"
        case symbol
        case side
        case size
        case fundingRate = "funding_rate"
        case fee = "exec_fee"
        case timeOfSettlement = "exec_timestamp"
    }
    
    internal init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.returnCode = try values.decode(Int.self, forKey: .returnCode)
        self.exitCode = try values.decode(String.self, forKey: .exit)
        self.exitInfo = try values.decodeIfPresent(String.self, forKey: .info)
        self.time = try values.decode(String.self, forKey: .time)
        self.response = try values.decode(Response.self, forKey: .response)
        
        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        
        self.symbol = try dictionary.decode(String.self, forKey: .symbol)
        self.side = try dictionary.decode(String.self, forKey: .side)
        self.size = try dictionary.decode(Int.self, forKey: .size)
        self.fundingRate = try dictionary.decode(Double.self, forKey: .fundingRate)
        self.fee = try dictionary.decode(Double.self, forKey: .fee)
        self.timeOfSettlement = try dictionary.decode(Double.self, forKey: .timeOfSettlement)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(symbol, forKey: .symbol)
        try container.encode(side, forKey: .size)
        try container.encode(size, forKey: .size)
        try container.encode(fundingRate, forKey: .fundingRate)
        try container.encode(fee, forKey: .fee)
        try container.encode(timeOfSettlement, forKey: .timeOfSettlement)
    }
}
