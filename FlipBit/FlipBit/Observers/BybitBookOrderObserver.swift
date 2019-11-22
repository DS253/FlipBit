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
    
    init(url: URLRequest?) {
        if let urlRequest = url {
            socket = WebSocket(request: urlRequest)
            socket?.delegate = self
            socket?.connect()
        } else { print("The URL is invalid") }
    }
    
    func webSocketDidWrite() {
        socket.write(string: "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25.BTCUSD\"]}")
        print("socket did write")
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
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
        //print("Received text: \(text)")
        
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
            let snapshot = dictionary.parseSnapshot()
            print("Topic: \(snapshot.topic)")
            print("Type: \(snapshot.type)")
            print("Timestamp: \(snapshot.timestamp)")
            print("CrossSequence: \(snapshot.crossSequence)")
            print(snapshot.book)
        } else if (dictionary["data"] as? Dictionary<String, Any>) != nil {
            let update = dictionary.parseBookUpdate()
            print("Topic: \(update.topic)")
            print("Type: \(update.type)")
            print("TransactionTime: \(update.transactionTime)")
            print("CrossSequence: \(update.crossSequence)")
            print("Deletes: \(update.deletes)")
            print("Updates: \(update.updates)")
            print("Inserts: \(update.inserts)")
        }
        
        if dictionary.keys.contains("success") {
            let response = parseSocketResponse(dictionary: dictionary)
            print("Success: \(response.success)")
            print("Message: \(response.message)")
            print("Connection ID: \(response.connectionID)")
            print("Operations: \(response.operation)")
            print("Arguments: \(response.arguments)")
        }
    }
    
    struct SocketResponse {
        var success: Bool?
        var message: String?
        var connectionID: String?
        var operation: String?
        var arguments: [String]?
    }
        
    func parseSocketResponse(dictionary: Dictionary<String, Any>) -> SocketResponse {

        var response = SocketResponse()
        response.success = dictionary["success"] as? Bool
        response.message = dictionary["ret_msg"] as? String
        response.connectionID = dictionary["conn_id"] as? String
        guard
            let request = dictionary["request"] as? [String: Any]
            else { return response }
        response.operation = request["op"] as? String
        response.arguments = request["args"] as? [String]

        return response
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
}
