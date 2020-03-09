//
//  BBActiveOrderUpdate+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitActiveOrderUpdate {
    
    struct Endpoint: Requestable {
        
        var orderID: String
        var symbol: Bybit.Symbol
        var quantity: Int?
        var price: Double?
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/open-api/order/replace")
        }
        
        var method: Atom.Method {
            return .post(Data())
        }
        
        var signature: String {
            var queries = "api_key=\(theAPIKey)"
            queries.append("&order_id=\(orderID)")
            
            if let newPrice = self.price { queries.append("&p_r_price=\(newPrice)") }
            if let newQuantity = self.quantity { queries.append("&p_r_qty=\(newQuantity)") }
            
            queries.append("&recv_window=1000000")
            queries.append("&symbol=\(symbol.rawValue)")
            queries.append("&timestamp=\(timestamp)")
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            var queryItems = [Atom.QueryItem]()
            queryItems.append(Atom.QueryItem(name: "api_key", value: theAPIKey))
            queryItems.append(Atom.QueryItem(name: "order_id", value: orderID))

            if let newPrice = self.price { queryItems.append(Atom.QueryItem(name: "p_r_price", value: String(newPrice))) }
            if let newQuantity = self.quantity { queryItems.append(Atom.QueryItem(name: "p_r_qty", value: String(newQuantity))) }
            
            queryItems.append(Atom.QueryItem(name: "recv_window", value: "1000000"))
            queryItems.append(Atom.QueryItem(name: "symbol", value: symbol.rawValue))
            queryItems.append(Atom.QueryItem(name: "timestamp", value: timestamp))
            queryItems.append(Atom.QueryItem(name: "sign", value: signature))
            return queryItems
        }
        
        init(orderID: String, symbol: Bybit.Symbol, quantity: Int? = nil, price: Double? = nil, timeStamp: String) {
            self.orderID = orderID
            self.symbol = symbol
            self.quantity = quantity
            self.price = price
            self.timestamp = timeStamp
        }
    }
}
