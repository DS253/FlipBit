//
//  Requestable+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

internal extension Requestable {
    /// Returns default header values for `BitService` framework.
    var headerItems: [Atom.HeaderItem]? {
        return [
            Atom.HeaderItem(name: HeaderKeys.apiVersion, value: HeaderValues.apiVersion),
            Atom.HeaderItem(name: HeaderKeys.subscriptionKey, value: application.environment.subscriptionKey),
            Atom.HeaderItem(name: HeaderKeys.contentType, value: HeaderValues.contentType)
        ]
    }
    
    /// Returns default `baseURL` values based on environment for `BitService` framework.
    func baseURL() throws -> Atom.BaseURL {
        switch application.environment {
        case .testnet:
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        case .mainnet:
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
    }
}
