//
//  NetQuiltError+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/13/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuiltError {
    /// Convenience method for decoding error objects or messages returned by the session.
    ///
    /// JSON decoder with the default formatting and decoding settings.
    ///
    /// - Parameters:
    ///   - type: The type to decode.
    ///
    /// - Returns: An optional instance of type `T` if `NetQuiltError` is `.response`, and contains valid data, `nil` otherwise.
    func decodeIfPresent<T: Decodable>(as type: T.Type) throws -> T? {
        guard case .response(let response) = self, let data = response.data else { return nil }
        
        return try JSONDecoder().decode(type, from: data)
    }
}
