//
//  BybitOrderBook.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/19/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

struct BookOrder {
    var price: String?
    var symbol: String?
    var id: Int?
    var side: String?
    var size: Int?
}

struct BookOrderSnapshot {
    var topic: String?
    var type: String?
    var book: [BookOrder]?
    var crossSequence: Int?
    var timestamp: Int?
}

struct BookUpdate {
    var topic: String?
    var type: String?
    var deletes: [BookOrder]?
    var updates: [BookOrder]?
    var inserts: [BookOrder]?
    var transactionTime: Int?
    var crossSequence: Int?
    var timestamp: Int?
}

extension Array {
    func parseBookOrders() -> [BookOrder] {
        var bookOrders = [BookOrder]()
        
        for anOrder in self {
            guard let dictionary = anOrder as? Dictionary<String, Any>
                else { continue }
            var order = BookOrder()
            order.price = dictionary["price"] as? String
            order.symbol = dictionary["symbol"] as? String
            order.id = dictionary["id"] as? Int
            order.side = dictionary["side"] as? String
            order.size = dictionary["size"] as? Int
            bookOrders.append(order)
        }
        
        return bookOrders
    }
}

extension Dictionary {
    func parseBookUpdate() -> BookUpdate {
        guard let update = self as? Dictionary<String, Any> else { return BookUpdate() }
        var bookUpdate = BookUpdate()
        bookUpdate.topic = update["topic"] as? String
        bookUpdate.type = update["type"] as? String
        bookUpdate.crossSequence = update["cross_seq"] as? Int
        bookUpdate.timestamp = update["timestamp_e6"] as? Int
        
        guard
            let data = update["data"] as? Dictionary<String, Any>,
            let deletes = data["delete"] as? [Dictionary<String, Any>],
            let updates = data["update"] as? [Dictionary<String, Any>],
            let inserts = data["insert"] as? [Dictionary<String, Any>]
            else { return bookUpdate }
        
        bookUpdate.deletes = deletes.parseBookOrders()
        bookUpdate.updates = updates.parseBookOrders()
        bookUpdate.inserts = inserts.parseBookOrders()
        
        return bookUpdate
    }
    
    func parseSnapshot() -> BookOrderSnapshot {
        guard let dictionary = self as? Dictionary<String, Any> else { return BookOrderSnapshot() }
        var snapshot = BookOrderSnapshot()
        snapshot.topic = dictionary["topic"] as? String
        snapshot.type = dictionary["type"] as? String
        snapshot.crossSequence = dictionary["cross_seq"] as? Int
        snapshot.timestamp = dictionary["timestamp_e6"] as? Int
        
        guard
            let allOrders = dictionary["data"] as? [Dictionary<String, Any>]
            else { return snapshot }
        snapshot.book = allOrders.parseBookOrders()
        return snapshot
    }
}
