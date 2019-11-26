//
//  BBTickers+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitTickerList {
    
    struct Endpoint: Requestable {
        
        var symbol: Bybit.Symbol

        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/v2/public/tickers")
        }
        
        var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "symbol", value: self.symbol.rawValue)]
        }
        
        init(symbol: Bybit.Symbol) {
            self.symbol = symbol
        }
    }
}
