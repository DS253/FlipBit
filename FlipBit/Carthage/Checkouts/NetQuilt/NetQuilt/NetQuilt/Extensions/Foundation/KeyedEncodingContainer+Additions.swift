//
//  KeyedEncodingContainer+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension KeyedEncodingContainer {
    /// Encodes an object into Data.
    ///
    /// Objective-C types do not conform to `Codable` protocol. This implementation
    /// adds the ability for `KeyedEncodingContainer` to encode an Objective-C type into Data
    /// assuming given type conforms to `NSCoding` protocol.
    ///
    /// - Parameters:
    ///   - object: An object to encode.
    ///   - key:    The unique key to use for encoding.
    ///
    /// - Throws: `NSKeyedArchiver` error if the operation fails.
    mutating func encode<T: NSObject>(_ object: T, forKey key: KeyedEncodingContainer.Key) throws where T: NSCoding {
        try encode(NSKeyedArchiver.archivedData(withRootObject: object), forKey: key)
    }

    /// Encodes an object into Data, if present.
    ///
    /// Objective-C types do not conform to `Codable` protocol. This implementation
    /// adds the ability for `KeyedEncodingContainer` to encode an Objective-C type into Data
    /// assuming given type conforms to `NSCoding` protocol.
    ///
    /// - Parameters:
    ///   - object: An optional object to encode.
    ///   - key:    The unique key to use for encoding.
    ///
    /// - Throws: `NSKeyedArchiver` error if the operation fails.
    mutating func encodeIfPresent<T: NSObject>(_ object: T?, forKey key: KeyedEncodingContainer.Key) throws where T: NSCoding {
        guard let object = object else { return }

        try encode(object, forKey: key)
    }
}
