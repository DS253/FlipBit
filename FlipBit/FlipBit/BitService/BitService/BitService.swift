//
//  BitService.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public struct BitService {
    /// The configuration data used for initializing `BitService` instance.
    private let configuration: BitService.Configuration
    
    /// Creates a `BitService` instance given the provided parameter(s).
    public init() {
        self.configuration = BitService.Configuration()
    }
}

public extension BitService {
    
    func lookupAPIKeyInfo(completion: @escaping (Result<BybitAPIKeyInfo, BitService.Error>) -> Void) {
        let endpoint = BybitAPIKeyInfo.Endpoint(timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitAPIKeyInfo.self, on: completion)
    }
}
