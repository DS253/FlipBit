//
//  Requestable+Implementation.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// Default implementationretu for `Requestable` protocol.
public extension Requestable {
    /// The default value is `nil`.
    var headerItems: [NetQuilt.HeaderItem]? {
        return nil
    }
    
    /// The default value is `.get`.
    var method: NetQuilt.Method {
        return .get
    }
    
    /// The default value is `nil`.
    var queryItems: [NetQuilt.QueryItem]? {
        return nil
    }
    
    /// The default value is `NetQuilt.URLPath.default`.
    func path() throws -> NetQuilt.URLPath {
        return NetQuilt.URLPath.default
    }
}
