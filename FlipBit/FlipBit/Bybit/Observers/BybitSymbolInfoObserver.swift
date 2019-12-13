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
    
    var symbolInfo: Bybit.SymbolInfo?
    
    // MARK: Websocket Delegate Methods.
    
    override func websocketDidConnect(socket: WebSocketClient) {
        print("Subscribing to SymbolInfo socket")
        writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"instrument_info.100ms.BTCUSD\"]}")
        print("SymbolInfoObserver sending heartbeat package")
        sendHeartbeatPackage()
    }

    override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let encodedData = convertToData(text)
        let responseType = determineSymbolInfoResponseType(encodedData)
        guard
            let data = encodedData,
            responseType != .DecodingFailure
            else {
                print("Failed to decode Bybit SymbolInfo Response")
                return
        }
        
        switch responseType {
        case .Snapshot:
            if let firstSnapshot = try? Bybit.SymbolInfoSnapshot(from: data) {
                symbolInfo = firstSnapshot.symbol
                NotificationCenter.default.post(name: .symbolObserverUpdate, object: nil)
            } else {
                print("Failed to decode Bybit SymbolInfo Snapshot")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .Update:
            guard
                let update = try? Bybit.SymbolInfoUpdate(from: data),
                let allSymbols = update.symbols,
                let updatedSymbol = allSymbols.first
                else {
                    print("Failed to decode Bybit SymbolInfo Update")
                    delegate?.observerFailedToDecode(observer: self)
                    return
            }
            symbolInfo?.updateSymbolInfo(newSymbol: updatedSymbol)
            NotificationCenter.default.post(name: .symbolObserverUpdate, object: nil)
        case .SocketResponse:
            if let socketResponse = try? Bybit.SocketResponse(from: data) {
                response = socketResponse
            } else {
                print("Failed to decode Bybit SymbolInfo SocketResponse")
                delegate?.observerFailedToDecode(observer: self)
            }
        default:
            print("Decoding SymbolInfo Response Failed")
            delegate?.observerFailedToDecode(observer: self)
        }
    }
}
