//
//  BybitPositionObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/3/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

class BybitPositionObserver: BybitObserver {
    
    var authenticated: Bool = false
    
    func authenticateWithSocket() {
        let apikey = theAPIKey
        let expires = Date().bybitTimestamp()
        let signature = "GET/realtime\(expires)".buildSignature(secretKey: secret)
        writeToSocket(topic: "{\"op\": \"auth\", \"args\": [\"\(apikey)\", \"\(expires)\", \"\(signature)\"]}")
    }
    
    // MARK: Websocket Delegate Methods.
    
    override func websocketDidConnect(socket: WebSocketClient) {
        print("Authenticating PositionInfo socket")
        if !authenticated {
            authenticateWithSocket()
            authenticated = true
        } else {
            writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"position\"]}")
            print("PositionObserver sending heartbeat package")
            sendHeartbeatPackage()
        }
    }
    
    override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        let encodedData = convertToData(text)
        let responseType = determinePositionResponseType(encodedData)
        
        guard
            let data = encodedData,
            responseType != .DecodingFailure
            else {
                print("Failed to decode Bybit Position SocketResponse")
                return
        }
        
        switch responseType {
        case .SocketResponse:
            guard
                let socketResponse = try? Bybit.SocketResponse(from: data),
                let success = socketResponse.success,
                success == true
                else {
                    print("Decoding Position Response Failed")
                    delegate?.observerFailedToDecode(observer: self)
                    return
            }
            if socketResponse.operation == "auth" {
                authenticated = true
                writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"position\"]}")
            } else if socketResponse.operation == "subscribe" {
                response = socketResponse
            } else {
                print("Decoding Position Response Failed")
                delegate?.observerFailedToDecode(observer: self)
            }
            
        default:
            print("Nothing for now")
        }
    }
    
    func determinePositionResponseType(_ data: Data?) -> Bybit.SymbolInfoResponseResult {
        guard
            let response = data,
            let dictionary = try? JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, Any>
            else {
                return .UnknownResponse
        }
        
        if dictionary.keys.contains("success") { return .SocketResponse }

        return .UnknownResponse
    }
}
