//
//  BBTradeRecord+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitTradeRecords {
    
    struct Endpoint: Requestable {
        
        var symbol: Bybit.Symbol
        var pageNumber: Int
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/v2/private/execution/list")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&limit=50&page=\(pageNumber)&symbol=\(symbol.rawValue)&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            return [Atom.QueryItem(name: "api_key", value: theAPIKey),
                    Atom.QueryItem(name: "limit", value: "50"),
                    Atom.QueryItem(name: "page", value: String(pageNumber)),
                    Atom.QueryItem(name: "symbol", value: symbol.rawValue),
                    Atom.QueryItem(name: "timestamp", value: timestamp),
                    Atom.QueryItem(name: "sign", value: signature)]
        }
        
        init(symbol: Bybit.Symbol, pageNumber: Int, timeStamp: String) {
            self.symbol = symbol
            self.pageNumber = pageNumber
            self.timestamp = timeStamp
        }
    }
}
