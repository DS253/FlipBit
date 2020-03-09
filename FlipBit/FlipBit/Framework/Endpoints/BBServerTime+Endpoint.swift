//
//  BBServerTime+Endpoint.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

extension BitService.BybitServerTime {

    struct Endpoint: Requestable {

        internal func baseURL() throws -> Atom.BaseURL {
            return try Atom.BaseURL(host: "api-testnet.bybit.com")
        }

        internal func path() throws -> Atom.URLPath {
            return try Atom.URLPath("/v2/public/time")
        }
    }
}
