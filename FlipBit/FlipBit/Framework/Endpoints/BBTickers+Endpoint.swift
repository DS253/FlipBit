//
//  BBTickers+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitTickerList {
    
    struct Endpoint: Requestable {
        
        var symbol: Bybit.Symbol
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/v2/public/tickers")
        }
        
        var queryItems: [Atom.QueryItem]? {
            return [Atom.QueryItem(name: "symbol", value: self.symbol.rawValue)]
        }
        
        init(symbol: Bybit.Symbol) {
            self.symbol = symbol
        }
    }
}
