//
//  Array+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// Adds the ability to specify an array as the expected decoded type.
///
/// Each element must conform to `Model` protocol.
extension Array: Model where Element: Model { }

// MARK: Internal

internal extension Array where Element == NetQuilt.HeaderItem {
    /// Returns an array of `NetQuil.HeaderItem` as a dictionary.
    var dictionary: [String: String] {
        return reduce([:]) {
            var result = $0
            result[$1.name] = $1.value
            return result
        }
    }
}
