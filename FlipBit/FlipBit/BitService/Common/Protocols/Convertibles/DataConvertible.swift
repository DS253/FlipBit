//
//  DataConvertible.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

/// The `DataConvertible` protocol provides a default implementation of the conformance to `Codable` and the the ability to encode `self` to `Data`.
public protocol DataConvertible: Codable {
    /// The `Data` representation of `self`.
    var data: Data { get }
}

extension DataConvertible {
    /// The `Data` representation of `self`.
    public var data: Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let encoded = try? encoder.encode(self)

        return encoded.unwrap({ "Encoding of a model should never fail." })
    }
}
