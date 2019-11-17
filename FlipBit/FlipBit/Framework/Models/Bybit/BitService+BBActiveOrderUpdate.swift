//
//  BitService+BBActiveOrderUpdate.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    struct BybitActiveOrderUpdate {
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitActiveOrderUpdate: Model {
    
    public init(from decoder: Decoder) throws {
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try metaData.encode(to: encoder)
    }
}
