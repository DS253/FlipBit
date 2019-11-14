//
//  BBPreviousFundingRate+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/13/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitPreviousFundingRate {
    
    struct Endpoint: Requestable {
        
        var symbol: BitService.BybitSymbol
        var timestamp: String
        
        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }
    
        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/open-api/funding/prev-funding-rate")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&symbol=\(symbol.rawValue)&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "api_key", value: theAPIKey),
                    NetQuilt.QueryItem(name: "symbol", value: symbol.rawValue),
                    NetQuilt.QueryItem(name: "timestamp", value: timestamp),
                    NetQuilt.QueryItem(name: "sign", value: signature)]
        }
        
        init(symbol: BitService.BybitSymbol, timeStamp: String) {
            self.symbol = symbol
            self.timestamp = timeStamp
        }
    }
}
