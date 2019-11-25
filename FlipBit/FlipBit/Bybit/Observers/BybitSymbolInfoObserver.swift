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
    
//    var response: Bybit.SocketResponse?
//    var snapshot: Bybit.BookOrderSnapshot?
//    var buyBook: [Bybit.BookOrder?]?
//    var sellBook: [Bybit.BookOrder?]?
    
    // MARK: Websocket Delegate Methods.
    
    override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
    }
}
