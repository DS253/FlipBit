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
internal func wait(_ time: DispatchTimeInterval, completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: completion)
}

internal let bookObserver: BybitBookOrderObserver = {
    var request = URLRequest(url: URL(string: "wss://stream-testnet.bybit.com/realtime")!)
    request.timeoutInterval = 5
    return BybitBookOrderObserver(url: request)
}()

internal let symbolObserver: BybitSymbolInfoObserver = {
    var request = URLRequest(url: URL(string: "wss://stream-testnet.bybit.com/realtime")!)
    request.timeoutInterval = 5
    return BybitSymbolInfoObserver(url: request)
}()
