//
//  BitService+Response.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    /// The metadata associated with the response to a URL load request, independent of protocol and URL scheme.
    @dynamicMemberLookup
    struct Response {
        /// The `NetQuilt.Response` instance used for dynamic member lookup.
        private let response: NetQuilt.Response
        
        /// Creates a `Response` instance given the provided parameter(s).
        ///
        /// - Parameters:
        ///   - response: The `NetQuilt.Response` instance used for dynamic member lookup.
        internal init(_ response: NetQuilt.Response) {
            self.response = response
        }
        
        // MARK: Dynamic Member Lookup
        
        public subscript<T>(dynamicMember keyPath: KeyPath<NetQuilt.Response, T>) -> T {
            response[keyPath: keyPath]
        }
    }
}
