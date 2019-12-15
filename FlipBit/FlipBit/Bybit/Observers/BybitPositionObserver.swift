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
    
    func authenticateWithSocket() {
        let apikey = theAPIKey
        let expires = Date().bybitSocketTimestamp()
        let signature = "GET/realtime\(expires)".buildSignature(secretKey: secret)
        writeToSocket(topic: "{\"op\": \"auth\", \"args\": [\"\(apikey)\", \"\(expires)\", \"\(signature)\"]}")
    }
    
    // MARK: Websocket Delegate Methods.
    
    override func websocketDidConnect(socket: WebSocketClient) {
        writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"position\"]}")
        sendPing()
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
            response = socketResponse
            
        default:
            print("Nothing for now")
        }
    }
    
    func determinePositionResponseType(_ data: Data?) -> Bybit.PositionResponseResult {
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
