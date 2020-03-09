//
//  BBLeverageStatus+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitLeverageStatus {
    
    struct Endpoint: Requestable {
        
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/user/leverage")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&recv_window=1000000&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            return [Atom.QueryItem(name: "api_key", value: theAPIKey),
                    Atom.QueryItem(name: "recv_window", value: "1000000"),
                    Atom.QueryItem(name: "timestamp", value: timestamp),
                    Atom.QueryItem(name: "sign", value: signature)]
        }
        
        init(timeStamp: String) {
            self.timestamp = timeStamp
        }
    }
}
