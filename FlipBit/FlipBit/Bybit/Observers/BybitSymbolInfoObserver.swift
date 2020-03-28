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
    
    override func socketMessage() -> String {
        return "{\"op\": \"subscribe\", \"args\": [\"instrument_info.100ms.BTCUSD\"]}"
    }
    
    override func processData(data: Data?) {
        let responseType = determineSymbolInfoResponseType(data)
        guard
            let newData = data,
            responseType != .DecodingFailure
            else {
                print("Failed to decode Bybit SymbolInfo Response")
                return
        }
        
        switch responseType {
        case .Snapshot:
            if let firstSnapshot = try? Bybit.SymbolInfoSnapshot(from: newData) {
                symbolInfo = firstSnapshot.symbol
                NotificationCenter.default.post(name: .symbolObserverUpdate, object: nil)
            } else {
                print("Failed to decode Bybit SymbolInfo Snapshot")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .Update:
            guard
                let update = try? Bybit.SymbolInfoUpdate(from: newData),
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
            if let socketResponse = try? Bybit.SocketResponse(from: newData) {
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
