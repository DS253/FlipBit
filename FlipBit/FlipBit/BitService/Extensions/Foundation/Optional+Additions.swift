//
//  Optional+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal extension Optional {
    /// Unwraps an optional value. Terminates the process if the value is `nil`.
    ///
    /// - Warning:
    ///   While useful for eliminating the need for `if let` check for guaranteed values,
    ///   unwrapping `nil` optionals will result in a crash.
    ///
    ///
    /// - Parameters:
    ///   - because: The reason / expectation for why the value will never be `nil`.
    ///   - file:    The filename where the method is called from.
    ///   - line:    The line number where the method is called from.
    ///
    /// - Returns: Value of the expected type.
    func unwrap(_ because: (() -> String)? = nil, file: StaticString = #file, line: UInt = #line) -> Wrapped {
        if let value = self { return value }
        
        let message = because?() ?? "Unexpectedly found nil when unwrapping \(Wrapped.self)."
        
        fatalError(message, file: file, line: line)
    }
}
