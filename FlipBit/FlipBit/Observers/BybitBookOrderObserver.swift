//
//  BybitBookOrderObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/21/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

internal protocol SocketObserverDelegate: class {
    func observer(observer: WebSocketDelegate, didWriteToSocket: String)
    func observerFailedToConnect()
    func socketObserver(observer: WebSocketDelegate, didConnectToSocket: Bool)
    func observerDidConnect(observer: WebSocketDelegate)
    func observerDidReceiveMessage(observer: WebSocketDelegate, didReceiveMessage: String)
}

class BybitBookOrderObserver: WebSocketDelegate {

    var socket: WebSocket?
    weak var delegate: SocketObserverDelegate?
    var snapshot: BookOrderSnapshot?
    
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
        delegate?.socketObserver(observer: self, didConnectToSocket: true)
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
        delegate?.observerDidReceiveMessage(observer: self, didReceiveMessage: text)
        guard
            let data = text.data(using: String.Encoding.utf8)
            else {
                print("NOOOOOO")
                return
        }

        guard
            let anyobject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)),
            let dictionary = anyobject as? Dictionary<String, Any>
            else { return }

        if (dictionary["data"] as? [Dictionary<String, Any>]) != nil {
            snapshot = try? JSONDecoder().decode(BookOrderSnapshot.self, from: data)
            print(snapshot)
        } else if (dictionary["data"] as? Dictionary<String, Any>) != nil {
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let bookUpdate = try? JSONDecoder().decode(BookUpdate.self, from: data)
            print(bookUpdate?.topic)
            print(bookUpdate?.type)
            print(bookUpdate?.crossSequence)
            print(bookUpdate?.timestamp)
            print(bookUpdate?.delete)
            print(bookUpdate?.update)
            print(bookUpdate?.insert)
        }
        if dictionary.keys.contains("success") {
            let response = try? JSONDecoder().decode(BybitSocketResponse.self, from: data)
            print(response)
        }
}
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
}
