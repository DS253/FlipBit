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
        
    // MARK: Websocket Delegate Methods.

    override func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
        print("BookOrderObserver sending heartbeat package")
        sendHeartbeatPackage()
    }
    
    override func websocketDidConnect(socket: WebSocketClient) {
        print("Subscribing to Orderbook socket")
        writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25.BTCUSD\"]}")
    }

    override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let encodedData = convertToData(text)
        let responseType = determineBookOrderResponseType(encodedData)
        
        guard
            let data = encodedData,
            responseType != .DecodingFailure
            else {
                print("Failed to decode Bybit BookOrder Response")
                return
        }
        
        switch responseType {
        case .Snapshot:
            if let firstSnapshot = try? Bybit.BookOrderSnapshot(from: data) {
                snapshot = firstSnapshot
                sortBookOrders(snapshot?.book?.filter { $0.side == Bybit.Side.Buy }, side: Bybit.Side.Buy)
                NotificationCenter.default.post(name: .buyBookObserverUpdate, object: nil)
                sortBookOrders(snapshot?.book?.filter { $0.side == Bybit.Side.Sell }, side: Bybit.Side.Sell)
                NotificationCenter.default.post(name: .sellBookObserverUpdate, object: nil)
            } else {
                print("Failed to decode Bybit BookOrder Snapshot")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .Update, .Delete, .Insert:
            if let bookUpdate = try? Bybit.BookUpdate(from: data) {
                updateBookOrders(bookUpdate.update?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                deleteBookOrders(bookUpdate.delete?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                insertBookOrders(bookUpdate.insert?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                
                updateBookOrders(bookUpdate.update?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
                deleteBookOrders(bookUpdate.delete?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
                insertBookOrders(bookUpdate.insert?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
            } else {
                print("Failed to decode Bybit BookOrder Update")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .SocketResponse:
            if let socketResponse = try? Bybit.SocketResponse(from: data) {
                response = socketResponse
            } else {
                print("Failed to decode Bybit BookOrder SocketResponse")
                delegate?.observerFailedToDecode(observer: self)
            }
        default:
            print("Decoding BookOrder Response Failed")
            delegate?.observerFailedToDecode(observer: self)
        }
    }
}
