//
//  BBApiKeyInfo+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitAPIKeyInfo {

    struct Endpoint: Requestable {
        
        var timestamp: String
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&recv_window=1000000&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        internal var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "api_key", value: theAPIKey),
                    NetQuilt.QueryItem(name: "recv_window", value: "1000000"),
                    NetQuilt.QueryItem(name: "timestamp", value: timestamp),
                    NetQuilt.QueryItem(name: "sign", value: signature)]
        }
        
        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/open-api/api-key")
        }
        
        init(timeStamp: String) {
            self.timestamp = timeStamp
        }
    }
}
