//
//  BBActiveOrderCancel+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitCancelledOrder {
    
    struct Endpoint: Requestable {
        
        var orderID: String?
        var orderLinkID: String?
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/open-api/order/cancel")
        }
        
        var method: Atom.Method {
            return .post(Data())
        }
        
        var signature: String {
            var queries = "api_key=\(theAPIKey)"
            if let order = self.orderID { queries.append("&order_id=\(order)") }
            if let orderLink = self.orderLinkID { queries.append("&order_link_id=\(orderLink)") }
            queries.append("&recv_window=1000000")
            queries.append("&timestamp=\(timestamp)")
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            var queryItems = [Atom.QueryItem]()
            queryItems.append(Atom.QueryItem(name: "api_key", value: theAPIKey))

            if let order = self.orderID { queryItems.append(Atom.QueryItem(name: "order_id", value: order)) }
            if let orderLink = self.orderLinkID { queryItems.append(Atom.QueryItem(name: "order_link_id", value: orderLink)) }
            
            queryItems.append(Atom.QueryItem(name: "recv_window", value: "1000000"))
            queryItems.append(Atom.QueryItem(name: "timestamp", value: timestamp))
            queryItems.append(Atom.QueryItem(name: "sign", value: signature))
            return queryItems
        }
        
        init(orderID: String? = nil, orderLinkID: String? = nil, timeStamp: String) {
            self.orderID = orderID
            self.orderLinkID = orderLinkID
            self.timestamp = timeStamp
        }
    }
}
