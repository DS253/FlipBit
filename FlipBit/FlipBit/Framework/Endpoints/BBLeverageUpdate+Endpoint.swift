//
//  BBLeverageUpdate+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitLeverageUpdate {
    
    struct Endpoint: Requestable {
        
        var leverage: String
        var symbol: BitService.BybitSymbol
        var timestamp: String
        
        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/user/leverage/save")
        }
        
        var method: NetQuilt.Method {
            return .post(Data())
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&leverage=\(leverage)&recv_window=1000000&symbol=\(symbol.rawValue)&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "api_key", value: theAPIKey),
                    NetQuilt.QueryItem(name: "leverage", value: leverage),
                    NetQuilt.QueryItem(name: "recv_window", value: "1000000"),
                    NetQuilt.QueryItem(name: "symbol", value: symbol.rawValue),
                    NetQuilt.QueryItem(name: "timestamp", value: timestamp),
                    NetQuilt.QueryItem(name: "sign", value: signature)]
        }
        
        init(symbol: BitService.BybitSymbol, leverage: String, timeStamp: String) {
            self.symbol = symbol
            self.leverage = leverage
            self.timestamp = timeStamp
        }
    }
}
