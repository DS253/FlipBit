//
//  URLComponents+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension URLComponents {
    /// Creates a `URLComponents` instance given the provided parameter(s).
    ///
    /// - Parameters:
    ///  - baseURLString:  The `Requestable` base URL string value.
    ///  - path:           The `Requestable` path string value.
    ///  - queryItems:     The `Requestable` queryItems.
    init?(_ baseURLString: String, path: String, queryItems: [NetQuilt.QueryItem]?) {
        self.init(string: baseURLString)
        self.path = path
        self.queryItems = queryItems
    }
}
