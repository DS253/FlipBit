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
    var connected: Bool = false
    
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
    
    func connectToSocket() {
        if !connected { socket?.connect() }
    }
    
    func disconnectFromSocket() {
        if connected { socket?.disconnect() }
    }
    
    func writeToSocket(topic: String) {
        guard let bybitSocket = socket else { return }
        bybitSocket.write(string: topic)
        delegate?.observer(observer: self, didWriteToSocket: topic)
    }
    
    func sendPing() {
        writeToSocket(topic: "{\"op\": \"ping\"}")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.sendPing()
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        fatalError("Child class must override method")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        connected = false
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
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
