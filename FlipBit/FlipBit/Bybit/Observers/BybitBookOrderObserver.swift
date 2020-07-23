//
//  BybitBookOrderObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/21/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

class BybitBookOrderObserver: BybitObserver {
    
    var snapshot: Bybit.BookOrderSnapshot?
    var buyBook: [Bybit.BookOrder?]?
    var sellBook: [Bybit.BookOrder?]?
    
    override func socketMessage() -> String {
        return "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25.BTCUSD\"]}"
    }
    
    override func processData(data: Data?) {
        let responseType = determineBookOrderResponseType(data)
        
        guard
            let newData = data,
            responseType != .DecodingFailure
            else {
                print("Failed to decode Bybit BookOrder Response")
                return
        }
        
        switch responseType {
        case .Snapshot:
            if let firstSnapshot = try? Bybit.BookOrderSnapshot(from: newData) {
                snapshot = firstSnapshot
                sortBookOrders(snapshot?.book?.filter { $0.side == Bybit.Side.Buy }, side: Bybit.Side.Buy)
                NotificationCenter.default.post(name: .buyBookObserverUpdate, object: nil)
                sortBookOrders(snapshot?.book?.filter { $0.side == Bybit.Side.Sell }, side: Bybit.Side.Sell)
                NotificationCenter.default.post(name: .sellBookObserverUpdate, object: nil)
            } else {
                print("Failed to decode Bybit BookOrder Snapshot")
            }
        case .Update, .Delete, .Insert:
            if let bookUpdate = try? Bybit.BookUpdate(from: newData) {
                updateBookOrders(bookUpdate.update?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                deleteBookOrders(bookUpdate.delete?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                insertBookOrders(bookUpdate.insert?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                
                updateBookOrders(bookUpdate.update?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
                deleteBookOrders(bookUpdate.delete?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
                insertBookOrders(bookUpdate.insert?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
            } else {
                print("Failed to decode Bybit BookOrder Update")
            }
        case .SocketResponse:
            if let socketResponse = try? Bybit.SocketResponse(from: newData) {
                response = socketResponse
            } else {
                print("Failed to decode Bybit BookOrder SocketResponse")
            }
        default:
            print("Decoding BookOrder Response Failed")
        }
    }
}
