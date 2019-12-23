//
//  Notification+Names.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/27/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let dismissFlow = Notification.Name("dismissFlow")
    static let buyBookObserverUpdate = Notification.Name("buyBookUpdated")
    static let symbolObserverUpdate = Notification.Name("symbolObserverUpdated")
    static let sellBookObserverUpdate = Notification.Name("sellBookUpdated")
    static let tradeEventObserverUpdate = Notification.Name("tradeEventsUpdated")
}
