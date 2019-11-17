//
//  BBActiveOrder+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

extension BitService.BybitActiveOrderList {
    
    struct Endpoint: Requestable {
        
        var symbol: BitService.BybitSymbol
        var pageNumber: Int
        var timestamp: String
        var orderStatus: BitService.BybitOrderStatus?
        
        internal func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> NetQuilt.URLPath {
            return try NetQuilt.URLPath("/open-api/order/list")
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
        
        var queryItems: [NetQuilt.QueryItem]? {
            var queryItems = [NetQuilt.QueryItem]()
            queryItems.append(NetQuilt.QueryItem(name: "api_key", value: theAPIKey))
            queryItems.append(NetQuilt.QueryItem(name: "limit", value: "50"))
            if let status = self.orderStatus { queryItems.append(NetQuilt.QueryItem(name: "order_status", value: status.rawValue)) }
            queryItems.append(NetQuilt.QueryItem(name: "page", value: String(pageNumber)))
            queryItems.append(NetQuilt.QueryItem(name: "recv_window", value: "1000000"))
            queryItems.append(NetQuilt.QueryItem(name: "symbol", value: symbol.rawValue))
            queryItems.append(NetQuilt.QueryItem(name: "timestamp", value: timestamp))
            queryItems.append(NetQuilt.QueryItem(name: "sign", value: signature))
            return queryItems
        }
        
        init(symbol: BitService.BybitSymbol, pageNumber: Int, orderStatus: BitService.BybitOrderStatus? = nil, timeStamp: String) {
            self.symbol = symbol
            self.pageNumber = pageNumber
            self.orderStatus = orderStatus
            self.timestamp = timeStamp
        }
    }
}