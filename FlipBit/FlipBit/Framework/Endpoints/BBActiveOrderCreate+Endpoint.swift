//
//  BBActiveOrderCreate+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/17/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitOrder {
    
    struct Endpoint: Requestable {
        
        var side: BitService.BybitOrderSide
        var symbol: Bybit.Symbol
        var orderType: BitService.BybitOrderType
        var quantity: Int
        var timeInForce: BitService.BybitOrderTimeInForce
        var orderPrice: Double?
        var takeProfitPrice: Double?
        var stopLossPrice: Double?
        var reduceOnly: Bool?
        var closeOnTrigger: Bool?
        var orderLinkID: String?
        var timestamp: String
        
        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }
        
        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/open-api/order/create")
        }
        
        var method: Atom.Method {
            return .post(Data())
        }
        
        var signature: String {
            var queries = "api_key=\(theAPIKey)"
            if let close = closeOnTrigger { queries.append("&close_on_trigger=\(close)") }
            if let linkID = orderLinkID { queries.append("&order_link_id=\(linkID)") }
            queries.append("&order_type=\(orderType.rawValue)")
            if let price = orderPrice { queries.append("&price=\(price)") }
            queries.append("&qty=\(quantity)")
            queries.append("&recv_window=1000000")
            if let reduce = reduceOnly { queries.append("&reduce_only=\(reduce)") }
            queries.append("&side=\(side.rawValue)")
            if let stopLoss = stopLossPrice { queries.append("&stop_loss=\(stopLoss)") }
            queries.append("&symbol=\(symbol.rawValue)")
            if let takeProfit = takeProfitPrice { queries.append("&take_profit=\(takeProfit)") }
            queries.append("&time_in_force=\(timeInForce)")
            queries.append("&timestamp=\(timestamp)")
            return queries.buildSignature(secretKey: secret)
        }
        
        var queryItems: [Atom.QueryItem]? {
            var queryItems = [Atom.QueryItem]()
            queryItems.append(Atom.QueryItem(name: "api_key", value: theAPIKey))
            
            if let close = closeOnTrigger { queryItems.append(Atom.QueryItem(name: "close_on_trigger", value: String(close))) }
            if let linkID = orderLinkID { queryItems.append(Atom.QueryItem(name: "order_link_id", value: linkID)) }
            
            queryItems.append(Atom.QueryItem(name: "order_type", value: orderType.rawValue))
            
            if let price = orderPrice { queryItems.append(Atom.QueryItem(name: "price", value: String(price))) }
            
            queryItems.append(Atom.QueryItem(name: "qty", value: String(quantity)))
            queryItems.append(Atom.QueryItem(name: "recv_window", value: "1000000"))
            
            if reduceOnly != nil { queryItems.append(Atom.QueryItem(name: "reduce_only", value: String(reduceOnly!))) }
            
            queryItems.append(Atom.QueryItem(name: "side", value: side.rawValue))
            
            if let stopLoss = stopLossPrice { queryItems.append(Atom.QueryItem(name: "stop_loss", value: String(stopLoss))) }
            
            queryItems.append(Atom.QueryItem(name: "symbol", value: symbol.rawValue))
            
            if let takeProfit = takeProfitPrice { queryItems.append(Atom.QueryItem(name: "take_profit", value: String(takeProfit))) }
            
            queryItems.append(Atom.QueryItem(name: "time_in_force", value: timeInForce.rawValue))
            queryItems.append(Atom.QueryItem(name: "timestamp", value: timestamp))
            queryItems.append(Atom.QueryItem(name: "sign", value: signature))
            
            return queryItems
        }
        
        init(side: BitService.BybitOrderSide, symbol: Bybit.Symbol, orderType: BitService.BybitOrderType, quantity: Int, timeInForce: BitService.BybitOrderTimeInForce,
             price: Double? = nil, takeProfit: Double? = nil, stopLoss: Double? = nil, reduceOnly: Bool? = nil, closeOnTrigger: Bool? = nil, orderLinkID: String? = nil, timeStamp: String) {
            self.quantity = quantity
            self.side = side
            self.symbol = symbol
            self.orderType = orderType
            self.timeInForce = timeInForce
            self.orderPrice = price
            self.takeProfitPrice = takeProfit
            self.stopLossPrice = stopLoss
            self.reduceOnly = reduceOnly
            self.closeOnTrigger = closeOnTrigger
            self.orderLinkID = orderLinkID
            self.timestamp = timeStamp
        }
    }
}
