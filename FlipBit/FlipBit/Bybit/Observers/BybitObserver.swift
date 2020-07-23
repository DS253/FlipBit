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
    
    var socket: WebSocket?
    var connected: Bool = false
    var response: Bybit.SocketResponse?
    
    init(url: URLRequest?) {
        if let urlRequest = url {
            socket = WebSocket(request: urlRequest, certPinner: nil)
            socket?.delegate = self
        } else {
            print("The URL is invalid")
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("Websocket is connected: \(headers)")
            connected = true
            writeToSocket(topic: socketMessage())
        case .disconnected(let reason, let code):
            connected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            let encodedData = convertToData(string)
            processData(data: encodedData)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            connected = false
        case .error(let error):
            connected = false
            print(error.debugDescription)
        }
    }
    
    func connectToSocket() {
        if !connected {
            print("Attempting to connect to socket")
            socket?.connect() }
    }
    
    func disconnectFromSocket() {
        if connected { socket?.disconnect() }
    }
    
    func writeToSocket(topic: String) {
        print("Attempting to write to socket.")
        socket?.write(string: topic)
    }
    
    func sendPing() {
        writeToSocket(topic: "{\"op\": \"ping\"}")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.sendPing()
        }
    }
    
    /// Converts the received string into a data object.
    func convertToData(_ text: String) -> Data? {
        return text.data(using: String.Encoding.utf8)
    }
    
    /// The expected message to be sent to the socket.
    func socketMessage() -> String {
        fatalError("Child class must override method")
    }
    
    /// Convert the data object into the expected models.
    func processData(data: Data?) {
        fatalError("Child class must override method")
    }
}
