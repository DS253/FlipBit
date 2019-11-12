//
//  Error+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension Error {
    /// Convenience variable for returning `NSError` in place of `Error`.
    var nsError: NSError {
        return self as NSError
    }
}
