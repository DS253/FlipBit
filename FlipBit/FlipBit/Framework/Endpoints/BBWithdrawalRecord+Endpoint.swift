//
//  BBWithdrawalRecord+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitWithdrawalRecords {
    struct Endpoint: Requestable {
        
        var currency: BitService.Currency
        var pageNumber: Int
        var timestamp: String
        
        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/open-api/wallet/withdraw/list")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&currency=\(currency.rawValue)&limit=50&page=\(pageNumber)&recv_window=1000000&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [NetQuilt.QueryItem]? {
            return [NetQuilt.QueryItem(name: "api_key", value: theAPIKey),
                    NetQuilt.QueryItem(name: "currency", value: currency.rawValue),
                    NetQuilt.QueryItem(name: "limit", value: "50"),
                    NetQuilt.QueryItem(name: "page", value: String(pageNumber)),
                    NetQuilt.QueryItem(name: "recv_window", value: "1000000"),
                    NetQuilt.QueryItem(name: "timestamp", value: timestamp),
                    NetQuilt.QueryItem(name: "sign", value: signature)]
        }
        
        init(currency: BitService.Currency, pageNumber: Int, timeStamp: String) {
            self.currency = currency
            self.pageNumber = pageNumber
            self.timestamp = timeStamp
        }
    }
}
