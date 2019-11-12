//
//  NetQuilt.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// A simple networking library.
public struct NetQuilt {

    /// The `NetQuilt.NetSession` instance.
    private let session: NetQuilt.NetSession
    
    /// Creates a `NetQuilt` instance given the provided parameter(s).
    ///
    /// - Parameters:
    ///   - serviceConfiguration: The session configuration data used for initializing `NetQuilt.NetSession` instance.
    public init(sessionConfiguration: NetQuilt.NetSessionConfiguration = NetQuilt.NetSessionConfiguration()) {
        self.session = NetQuilt.NetSession(sessionConfiguration: sessionConfiguration)
    }
}

public extension NetQuilt {
    /// Cancels all currently running and suspended tasks.
    ///
    /// Calling `cancelAllSessionTasks()` method will not invalide `URLSession`
    /// instance nor will it empty cookies, cache or credential stores.
    ///
    /// All subsequent tasks will occur on the same TCP connection.
    func cancelAllSessionTasks() {
        session.cancelAllSessionTasks()
    }
    
    /// Prepares `NetQuilt.NetSession` for a network call.
    ///
    /// Calling `load()` method will not initiate a network call until
    /// one of the available methods on `NetQuilt.NetSession` is called first.
    ///
    /// - Note:
    ///   Calling `load()` method multiple times without executing a network call will update
    ///   previously set `requestable` property on `NetQuilt.NetSession` with new value. `NetQuilt` framework
    ///   does not support queue based flow.
    ///
    /// - Parameters:
    ///   - requestable: The requestable item containing required data for a network call.
    ///
    /// - Returns: Updated `NetQuilt.NetSession` instance initialized using `NetQuilt.NetSessionConfiguration`.
    func load(_ requestable: Requestable) -> NetQuilt.NetSession {
        return session.update(with: requestable)
    }
}
