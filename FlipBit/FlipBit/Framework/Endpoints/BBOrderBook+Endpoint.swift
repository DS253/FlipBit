//
//  BBOrderBook+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitOrderbook {

    struct Endpoint: Requestable {
        
        var symbol: BitService.BybitSymbol

        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/v2/public/orderBook/L2")
        }
        
        var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "symbol", value: self.symbol.rawValue)]
        }
        
        init(symbol: BitService.BybitSymbol) {
            self.symbol = symbol
        }
    }
}
