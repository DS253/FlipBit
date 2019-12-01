//
//  BybitObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/25/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

class BybitObserver: WebSocketDelegate {
    
    weak var delegate: SocketObserverDelegate?
    
    var socket: WebSocket?
    var response: Bybit.SocketResponse?
    
    init(url: URLRequest?) {
        if let urlRequest = url {
            socket = WebSocket(request: urlRequest)
            socket?.delegate = self
            socket?.connect()
        } else {
            print("The URL is invalid")
            delegate?.observerFailedToConnect()
        }
    }
    
    func writeToSocket(topic: String) {
        guard let bybitSocket = socket else { return }
        bybitSocket.write(string: topic)
        delegate?.observer(observer: self, didWriteToSocket: topic)
        print("socket did write")
    }
    
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
        fatalError("Child class must provide the supported document")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    func convertToData(_ text: String) -> Data? {
        return text.data(using: String.Encoding.utf8)
    }
}
