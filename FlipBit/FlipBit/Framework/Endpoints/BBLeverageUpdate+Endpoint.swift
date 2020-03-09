//
//  BBLeverageUpdate+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitLeverageUpdate {
    
    struct Endpoint: Requestable {
        
        var leverage: String
        var symbol: Bybit.Symbol
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/user/leverage/save")
        }
        
        var method: Atom.Method {
            return .post(Data())
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&leverage=\(leverage)&recv_window=1000000&symbol=\(symbol.rawValue)&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            return [Atom.QueryItem(name: "api_key", value: theAPIKey),
                    Atom.QueryItem(name: "leverage", value: leverage),
                    Atom.QueryItem(name: "recv_window", value: "1000000"),
                    Atom.QueryItem(name: "symbol", value: symbol.rawValue),
                    Atom.QueryItem(name: "timestamp", value: timestamp),
                    Atom.QueryItem(name: "sign", value: signature)]
        }
        
        init(symbol: Bybit.Symbol, leverage: String, timeStamp: String) {
            self.symbol = symbol
            self.leverage = leverage
            self.timestamp = timeStamp
        }
    }
}
