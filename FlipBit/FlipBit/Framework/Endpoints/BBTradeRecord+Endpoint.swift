//
//  BBTradeRecord+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitTradeRecords {
    
    struct Endpoint: Requestable {
        
        var symbol: BitService.BybitSymbol
        var pageNumber: Int
        var timestamp: String
        
        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/v2/private/execution/list")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&limit=50&page=\(pageNumber)&recv_window=1000000&symbol=\(symbol.rawValue)&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "api_key", value: theAPIKey),
                    NetQuilt.QueryItem(name: "limit", value: "50"),
                    NetQuilt.QueryItem(name: "page", value: String(pageNumber)),
                    NetQuilt.QueryItem(name: "recv_window", value: "1000000"),
                    NetQuilt.QueryItem(name: "symbol", value: symbol.rawValue),
                    NetQuilt.QueryItem(name: "timestamp", value: timestamp),
                    NetQuilt.QueryItem(name: "sign", value: signature)]
        }
        
        init(symbol: BitService.BybitSymbol, pageNumber: Int, timeStamp: String) {
            self.symbol = symbol
            self.pageNumber = pageNumber
            self.timestamp = timeStamp
        }
    }
}
