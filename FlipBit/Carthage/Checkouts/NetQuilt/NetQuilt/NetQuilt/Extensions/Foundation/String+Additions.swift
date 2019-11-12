//
//  String+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension String {
    /// Returns a `NSRange` instance for the entire length of `self`.
    var lengthRange: NSRange {
        return NSRange(location: 0, length: count)
    }
    
    /// Returns a boolean value indicating if `self` is a valid URL host.
    ///
    /// Validation is done using `a NSRegularExpression` pattern.
    var isValidURLHost: Bool {
        guard let match = NSRegularExpression.urlHost.firstMatch(in: self, options: .anchored, range: lengthRange) else {
            return false
        }
        
        return NSEqualRanges(match.range, lengthRange)
    }
    
    /// Returns a boolean value indicating if `self` is a valid URL path.
    ///
    /// Validation is done using `a NSRegularExpression` pattern.
    var isValidURLPath: Bool {
        guard let match = NSRegularExpression.urlPath.firstMatch(in: self, options: .anchored, range: lengthRange) else {
            return false
        }
        
        return NSEqualRanges(match.range, lengthRange)
    }
}
