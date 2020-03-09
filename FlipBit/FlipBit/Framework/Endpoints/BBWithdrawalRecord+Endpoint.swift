//
//  BBWithdrawalRecord+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitWithdrawalRecords {
    struct Endpoint: Requestable {
        
        var currency: BitService.Currency
        var pageNumber: Int
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/open-api/wallet/withdraw/list")
        }
        
        var signature: String {
            let queries = "api_key=\(theAPIKey)&currency=\(currency.rawValue)&limit=50&page=\(pageNumber)&recv_window=1000000&timestamp=\(timestamp)"
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            return [Atom.QueryItem(name: "api_key", value: theAPIKey),
                    Atom.QueryItem(name: "currency", value: currency.rawValue),
                    Atom.QueryItem(name: "limit", value: "50"),
                    Atom.QueryItem(name: "page", value: String(pageNumber)),
                    Atom.QueryItem(name: "recv_window", value: "1000000"),
                    Atom.QueryItem(name: "timestamp", value: timestamp),
                    Atom.QueryItem(name: "sign", value: signature)]
        }
        
        init(currency: BitService.Currency, pageNumber: Int, timeStamp: String) {
            self.currency = currency
            self.pageNumber = pageNumber
            self.timestamp = timeStamp
        }
    }
}
