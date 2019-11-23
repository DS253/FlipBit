//
//  BybitBookOrderObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/21/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

class BybitBookOrderObserver: WebSocketDelegate {
    
    var socket: WebSocket?
    weak var delegate: SocketObserverDelegate?
    
    var response: Bybit.SocketResponse?
    var snapshot: Bybit.BookOrderSnapshot?
    var buyBook: [Bybit.BookOrder?]?
    var sellBook: [Bybit.BookOrder?]?
    
    init(url: URLRequest?) {
        if let urlRequest = url {
            socket = WebSocket(request: urlRequest)
            socket?.delegate = self
            socket?.connect()
            delegate?.observerDidConnect(observer: self)
        } else {
            print("The URL is invalid")
            delegate?.observerFailedToConnect()
        }
    }
    
    func writeToSocket(topic: String) {
        guard let bybitSocket = socket else { return }
        bybitSocket.write(string: topic)
        delegate?.observer(observer: self, didWriteToSocket: topic)
        //        bybitSocket.write(string: "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25.BTCUSD\"]}")
        print("socket did write")
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
        delegate?.observerDidConnect(observer: self)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
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
                sortBookOrders(snapshot?.book?.filter { $0.side == Bybit.Side.Sell }, side: Bybit.Side.Sell)
            } else {
                print("Failed to decode Bybit BookOrder Snapshot")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .Update:
            if let bookUpdate = try? Bybit.BookUpdate(from: data) {
                updateBookOrders(bookUpdate.update?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                updateBookOrders(bookUpdate.update?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
            } else {
                print("Failed to decode Bybit BookOrder Update")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .Delete:
            if let bookUpdate = try? Bybit.BookUpdate(from: data) {
                deleteBookOrders(bookUpdate.delete?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
                deleteBookOrders(bookUpdate.delete?.filter { $0.side == Bybit.Side.Sell }, side: .Sell)
            } else {
                print("Failed to decode Bybit BookOrder Update")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .Insert:
            if let bookUpdate = try? Bybit.BookUpdate(from: data) {
                insertBookOrders(bookUpdate.insert?.filter { $0.side == Bybit.Side.Buy }, side: .Buy)
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
        delegate?.observerDidReceiveMessage(observer: self, didReceiveMessage: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
}
