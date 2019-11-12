//
//  NetQuilt+HeaderItem.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// A single name-value pair for specifying HTTP header value modeled after `URLQueryItem`.
    struct HeaderItem {
        /// The name of the header item.
        internal let name: String

        /// The value of the header item.
        internal let value: String

        /// Creates a `HeaderItem` instance given the provided parameter(s).
        ///
        /// - Parameters:
        ///   - name:  The name of the header item.
        ///   - value: The value of the header item.
        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}
