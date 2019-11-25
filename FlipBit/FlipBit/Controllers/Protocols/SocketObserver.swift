//
//  SocketObserver.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import Starscream

protocol SocketObserverDelegate: class {
    func observer(observer: WebSocketDelegate, didWriteToSocket: String)
    func observerFailedToConnect()
    func observerDidConnect(observer: WebSocketDelegate)
    func observerDidReceiveMessage(observer: WebSocketDelegate)
    func observerFailedToDecode(observer: WebSocketDelegate)
}
