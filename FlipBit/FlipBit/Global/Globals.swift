//
//  Globals.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

/// Global Application instance.
internal let application = BitService.Application()

/// Global Service instance.
internal let service = BitService.Service()

/// Will wait the specified amount of time before executing completion.
internal func wait(_ time: Double, completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: completion)
}

internal let bookObserver: BybitBookOrderObserver = {
    var request = URLRequest(url: URL(string: "wss://stream.bybit.com/realtime")!)
    request.timeoutInterval = 5
    return BybitBookOrderObserver(url: request)
}()

internal let symbolObserver: BybitSymbolInfoObserver = {
    var request = URLRequest(url: URL(string: "wss://stream.bybit.com/realtime")!)
    request.timeoutInterval = 5
    return BybitSymbolInfoObserver(url: request)
}()

internal let tradeObserver: BybitTradeObserver = {
    var request = URLRequest(url: URL(string: "wss://stream.bybit.com/realtime")!)
    request.timeoutInterval = 5
    return BybitTradeObserver(url: request)
}()

internal let positionObserver: BybitPositionObserver = {
    let timestamp = Date().bybitSocketTimestamp()
    let signature = "GET/realtime\(timestamp)".buildSignature(secretKey: secret)
    let parameter = "wss://stream-testnet.bybit.com/realtime?api_key=\(theAPIKey)&expires=\(timestamp)&signature=\(signature)"
    let param = URL(string: parameter)
    if let url = param {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        return BybitPositionObserver(url: request)
    }
    
    return BybitPositionObserver(url: nil)
}()

//"wss://stream-testnet.bybit.com/realtime"
