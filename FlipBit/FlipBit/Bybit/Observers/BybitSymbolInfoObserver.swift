//
//  BybitSymbolInfoObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

class BybitSymbolInfoObserver: WebSocketDelegate {
    
    var socket: WebSocket?
    weak var delegate: SocketObserverDelegate?

    
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
        print(text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
}
