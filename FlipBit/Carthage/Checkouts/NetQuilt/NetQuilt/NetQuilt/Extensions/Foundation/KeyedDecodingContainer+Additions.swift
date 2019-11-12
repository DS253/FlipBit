//
//  KeyedDecodingContainer+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension KeyedDecodingContainer {
    /// Decodes an object of the given type.
    ///
    /// Objective-C types do not conform to `Codable` protocol. This implementation
    /// adds the ability for `KeyedDecodingContainer` to decode an Objective-C type from Data
    /// assuming given type conforms to `NSCoding` protocol.
    ///
    /// - Parameters:
    ///   - key:  The unique key to use for decoding.
    ///
    /// - Throws: `DecodingError` if the operation fails.
    ///
    /// - Returns: An object of T.Type if data can be unarchived successfully, throws otherwise.
    func decode<T: NSObject>(forKey key: KeyedDecodingContainer.Key) throws -> T where T: NSCoding {
        let data = try decode(Data.self, forKey: key)

        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else {
            throw DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: [key], debugDescription: String()))
        }

        return object
    }

    /// Decodes an object of the given type, if present.
    ///
    /// Objective-C types do not conform to `Codable` protocol. This implementation
    /// adds the ability for `KeyedDecodingContainer` to decode an Objective-C type from Data
    /// assuming given type conforms to `NSCoding` protocol.
    ///
    /// - Parameters:
    ///   - key:  The unique key to use for decoding.
    ///
    /// - Throws: `DecodingError` if the operation fails.
    ///
    /// - Returns: An object of T.Type if data can be unarchived successfully, nil otherwise.
    func decodeIfPresent<T: NSObject>(forKey key: KeyedDecodingContainer.Key) throws -> T? where T: NSCoding {
        guard let data = try? decode(Data.self, forKey: key) else { return nil }

        return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
    }
}
