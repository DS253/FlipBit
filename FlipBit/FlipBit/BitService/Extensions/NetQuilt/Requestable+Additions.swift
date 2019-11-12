//
//  Requestable+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

internal extension Requestable {
    /// Returns default header values for `BitService` framework.
    var headerItems: [NetQuilt.HeaderItem]? {
        return [
            NetQuilt.HeaderItem(name: HeaderKeys.apiVersion, value: HeaderValues.apiVersion),
            NetQuilt.HeaderItem(name: HeaderKeys.subscriptionKey, value: application.environment.subscriptionKey),
            NetQuilt.HeaderItem(name: HeaderKeys.contentType, value: HeaderValues.contentType)
        ]
    }
    
    /// Returns default `baseURL` values based on environment for `BitService` framework.
    func baseURL() throws -> NetQuilt.BaseURL {
        switch application.environment {
        case .testnet:
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        case .mainnet:
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }
    }
}
