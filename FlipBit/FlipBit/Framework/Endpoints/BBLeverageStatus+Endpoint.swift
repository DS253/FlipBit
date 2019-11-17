//
//  BBLeverageStatus+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitLeverageStatus {
    
    struct Endpoint: Requestable {
        
        var timestamp: String
        
        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }
    
        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/user/leverage")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&recv_window=1000000&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "api_key", value: theAPIKey),
                    NetQuilt.QueryItem(name: "recv_window", value: "1000000"),
                    NetQuilt.QueryItem(name: "timestamp", value: timestamp),
                    NetQuilt.QueryItem(name: "sign", value: signature)]
        }
        
        init(timeStamp: String) {
            self.timestamp = timeStamp
        }
    }
}
