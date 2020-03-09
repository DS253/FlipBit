//
//  BBActiveOrder+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitActiveOrderList {
    
    struct Endpoint: Requestable {
        
        var symbol: Bybit.Symbol
        var pageNumber: Int
        var timestamp: String
        var orderStatus: BitService.BybitOrderStatus?
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/open-api/order/list")
        }
        
        var signature: String {
            var queries = "api_key=\(theAPIKey)"
            queries.append("&limit=50")
            if let status = self.orderStatus { queries.append("&order_status=\(status.rawValue)") }
            queries.append("&page=\(pageNumber)")
            queries.append("&recv_window=1000000")
            queries.append("&symbol=\(symbol.rawValue)")
            queries.append("&timestamp=\(timestamp)")
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            var queryItems = [Atom.QueryItem]()
            queryItems.append(Atom.QueryItem(name: "api_key", value: theAPIKey))
            queryItems.append(Atom.QueryItem(name: "limit", value: "50"))
            if let status = self.orderStatus { queryItems.append(Atom.QueryItem(name: "order_status", value: status.rawValue)) }
            queryItems.append(Atom.QueryItem(name: "page", value: String(pageNumber)))
            queryItems.append(Atom.QueryItem(name: "recv_window", value: "1000000"))
            queryItems.append(Atom.QueryItem(name: "symbol", value: symbol.rawValue))
            queryItems.append(Atom.QueryItem(name: "timestamp", value: timestamp))
            queryItems.append(Atom.QueryItem(name: "sign", value: signature))
            return queryItems
        }
        
        init(symbol: Bybit.Symbol, pageNumber: Int, orderStatus: BitService.BybitOrderStatus? = nil, timeStamp: String) {
            self.symbol = symbol
            self.pageNumber = pageNumber
            self.orderStatus = orderStatus
            self.timestamp = timeStamp
        }
    }
}
