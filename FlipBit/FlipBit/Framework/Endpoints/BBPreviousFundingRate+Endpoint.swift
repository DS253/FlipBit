//
//  BBPreviousFundingRate+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/13/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitPreviousFundingRate {
    
    struct Endpoint: Requestable {
        
        var symbol: Bybit.Symbol
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/open-api/funding/prev-funding-rate")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&symbol=\(symbol.rawValue)&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            return [Atom.QueryItem(name: "api_key", value: theAPIKey),
                    Atom.QueryItem(name: "symbol", value: symbol.rawValue),
                    Atom.QueryItem(name: "timestamp", value: timestamp),
                    Atom.QueryItem(name: "sign", value: signature)]
        }
        
        init(symbol: Bybit.Symbol, timeStamp: String) {
            self.symbol = symbol
            self.timestamp = timeStamp
        }
    }
}
