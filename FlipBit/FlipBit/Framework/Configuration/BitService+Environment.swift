//
//  BitService+Environment.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal extension BitService {
    /// List of supported environments by `BitService` framework.
    enum Environment {
        /// The testnet environment.
        case testnet
        
        /// The mainnet environment.
        case mainnet
    }
}

// MARK: Initializers

internal extension BitService.Environment {
    /// Creates an `Environment` instance given the provided parameters.
    init() {
        self = .testnet
    }
}

// MARK: Subscription Key

internal extension BitService.Environment {
    /// Returns correct subscription key for current environment.
    var subscriptionKey: String {
        switch self {
        case .testnet:
            return "e52ba50121744f7c8e848f9bb1efff65"
        case .mainnet:
            return "b70b0d46432140e2bfe8df820313676a"
        }
    }
}
