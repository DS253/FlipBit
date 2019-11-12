//
//  NetQuilt+Endpoint.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension NetQuilt {
    /// Model object representing default `Endpoint` requestable used for initializing `NetQuilt.NetSession`.
    struct Endpoint: Requestable {
        func baseURL() throws -> NetQuilt.BaseURL {
            return try NetQuilt.BaseURL(host: String())
        }
    }
}
