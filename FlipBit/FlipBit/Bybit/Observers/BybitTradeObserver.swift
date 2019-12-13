//
//  BybitTradeObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/1/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

class BybitTradeObserver: BybitObserver {
    
    var tradeSnapshot: Bybit.TradeEventSnapshot?
    
    // MARK: Websocket Delegate Methods.
    
    override func websocketDidConnect(socket: WebSocketClient) {
        print("Subscribing to Trade Events socket")
        writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"trade.BTCUSD\"]}")
        print("TradeObserver sending heartbeat package")
        sendHeartbeatPackage()
    }
    
    override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let encodedData = convertToData(text)
        let responseType = determineTradeEventResponseType(encodedData)
        
        guard
            let data = encodedData,
            responseType != .DecodingFailure
            else {
                print("Failed to decode Bybit Trade Event SocketResponse")
                return
        }
        
        switch responseType {
        case .Snapshot:
            if let snapshot = try? Bybit.TradeEventSnapshot(from: data) {
                updateTradeEvents(newSnapshot: snapshot)
                NotificationCenter.default.post(name: .tradeEventObserverUpdate, object: nil)
            } else {
                print("Failed to decode Bybit TradeEvent SocketResponse")
                delegate?.observerFailedToDecode(observer: self)
            }
        case .SocketResponse:
            if let socketResponse = try? Bybit.SocketResponse(from: data) {
                response = socketResponse
            } else {
                print("Failed to decode Bybit TradeEvent SocketResponse")
                delegate?.observerFailedToDecode(observer: self)
            }
        default:
            print("Decoding TradeEvent Response Failed")
            delegate?.observerFailedToDecode(observer: self)
        }
    }
    
    func updateTradeEvents(newSnapshot: Bybit.TradeEventSnapshot) {
        /// If the observer does not have a `TradeEventSnapshot`, save the entire snapshot.
        if tradeSnapshot == nil { tradeSnapshot = newSnapshot }
            
            // If there is a snapshot but without saved trades, save all the new trades
        else if tradeSnapshot?.trades == nil {
            tradeSnapshot?.trades = newSnapshot.trades
            
            // Combine the arrays of the current and new trades, and return an array of specified size.
        } else {
            guard
                let snapshot = tradeSnapshot,
                let currentTrades = snapshot.trades,
                var trades = newSnapshot.trades
                else { return }
            
            trades.append(contentsOf: currentTrades)
            tradeSnapshot?.trades = Array(trades.prefix(25))
        }
    }
}
