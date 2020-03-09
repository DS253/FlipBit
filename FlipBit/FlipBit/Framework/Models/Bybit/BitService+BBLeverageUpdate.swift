//
//  BitService+BBLeverageUpdate.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

public extension BitService {
    /// A type that represents the current leverage for all Bybit symbols.
    struct BybitLeverageUpdate {
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitLeverageUpdate: Model {
    
    public init(from decoder: Decoder) throws {
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try metaData.encode(to: encoder)
    }
}
