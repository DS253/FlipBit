//
//  StringConvertible.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// The `StringConvertible` protocol declares an interface used for representing conforming types as a string.
///
/// `StringConvertible` is defined a used despite having similar protocols available in the Standard Library.
/// (ex: `CustomStringConvertible`). This is intentional due to documentation suggestions and warnings.
internal protocol StringConvertible {
    /// Returns conforming type as a loosely constructed string representation.
    var stringValue: String { get }
}
