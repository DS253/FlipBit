//
//  BitService+Response.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

public extension BitService {
    /// The metadata associated with the response to a URL load request, independent of protocol and URL scheme.
    @dynamicMemberLookup
    struct Response {
        /// The `Atom.Response` instance used for dynamic member lookup.
        private let response: Atom.Response
        
        /// Creates a `Response` instance given the provided parameter(s).
        ///
        /// - Parameters:
        ///   - response: The `Atom.Response` instance used for dynamic member lookup.
        internal init(_ response: Atom.Response) {
            self.response = response
        }
        
        // MARK: Dynamic Member Lookup
        
        public subscript<T>(dynamicMember keyPath: KeyPath<Atom.Response, T>) -> T {
            response[keyPath: keyPath]
        }
    }
}
