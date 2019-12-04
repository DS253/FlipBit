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
    
    func sendHeartbeatPackage() {
        print("Sending heartbeat package")
        writeToSocket(topic: "{\"op\": \"ping\"}")
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
        delegate?.observerDidConnect(observer: self)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        fatalError("Child class must override method")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        fatalError("Child class must override method")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    func convertToData(_ text: String) -> Data? {
        return text.data(using: String.Encoding.utf8)
    }
}
