//
//  BitService+BBLeverageStatus.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    /// A type that represents the current leverage for all Bybit symbols.
    struct BybitLeverageStatus {
        
        /// The current leverage for BTCUSD.
        let btcLeverage: Int
        
        /// The current leverage for ETHUSD.
        let ethLeverage: Int
        
        /// The current leverage for EOSUSD.
        let eosLeverage: Int
        
        /// The current leverage for XRPUSD.
        let xrpLeverage: Int
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitLeverageStatus: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
        case btc = "BTCUSD"
        case eth = "ETHUSD"
        case eos = "EOSUSD"
        case xrp = "XRPUSD"
        case leverage
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        
        let leverageDictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        let btcDictionary = try leverageDictionary.nestedContainer(keyedBy: CodingKeys.self, forKey: .btc)
        self.btcLeverage = try btcDictionary.decode(Int.self, forKey: .leverage)
        
        let ethDictionary = try leverageDictionary.nestedContainer(keyedBy: CodingKeys.self, forKey: .eth)
        self.ethLeverage = try ethDictionary.decode(Int.self, forKey: .leverage)
        
        let eosDictionary = try leverageDictionary.nestedContainer(keyedBy: CodingKeys.self, forKey: .eos)
        self.eosLeverage = try eosDictionary.decode(Int.self, forKey: .leverage)
        
        let xrpDictionary = try leverageDictionary.nestedContainer(keyedBy: CodingKeys.self, forKey: .xrp)
        self.xrpLeverage = try xrpDictionary.decode(Int.self, forKey: .leverage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(btcLeverage, forKey: .btc)
        try container.encode(ethLeverage, forKey: .eth)
        try container.encode(eosLeverage, forKey: .eos)
        try container.encode(xrpLeverage, forKey: .xrp)
    }
}
