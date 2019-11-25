//
//  BybitSymbolInfoObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

class BybitSymbolInfoObserver: BybitObserver {
    
    var snapshot: Bybit.SymbolInfoSnapshot?

//    var buyBook: [Bybit.BookOrder?]?
//    var sellBook: [Bybit.BookOrder?]?
    
    // MARK: Websocket Delegate Methods.
    
    override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        let encodedData = convertToData(text)
        let responseType = determineSymbolInfoResponseType(encodedData)
        
        guard
            let data = encodedData,
            responseType != .DecodingFailure
            else {
                print("Failed to decode Bybit BookOrder Response")
                return
        }
        
        switch responseType {
            
        }
    }
    
    func determineSymbolInfoResponseType(_ data: Data?) -> Bybit.SymbolInfoResponseResult {
        guard
            let response = data,
            let dictionary = try? JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, Any>
            else {
                return .UnknownResponse
        }
        
        if dictionary["type"] as? String == Bybit.FormatType.Snapshot.rawValue {
            return .Snapshot
        }
        
        if dictionary["type"] as? String == Bybit.FormatType.Update.rawValue {
            guard
                let bookUpdate = try? Bybit.BookUpdate(from: response),
                let update = bookUpdate.update,
                let delete = bookUpdate.delete,
                let insert = bookUpdate.insert
                else { return .DecodingFailure }
            if !update.isEmpty { return .Update }
            else if !delete.isEmpty { return .Delete }
            else if !insert.isEmpty { return .Insert }
            else { return .UnknownResponse }
        }
        
        
        if dictionary.keys.contains("success") {
            return .SocketResponse
        }
        
        return .UnknownResponse
    }
}
