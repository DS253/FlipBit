//
//  NetQuilt+URLPath.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// Model object reprenting a URL path.
    struct URLPath {
        /// The URL path as defined in RFC 3986.
        private let path: String
        
        /// Creates a `URLPath` instance given the provided parameter(s).
        ///
        /// - Parameters:
        ///   - path: The URL path as defined in RFC 3986.
        ///
        /// - Throws: `RequestableError.invalidURLPath` when URL path validation fails.
        public init(_ path: String) throws {
            guard path.isValidURLPath else {
                throw RequestableError.invalidURLPath
            }
            
            self.path = path
        }
    }
}

// MARK: StringConvertible

extension NetQuilt.URLPath: StringConvertible {
    var stringValue: String {
        return path
    }
}

private extension NetQuilt.URLPath {
    /// Creates a `URLPath` instance where the path is an empty string.
    ///
    /// This implementation is used by internal static constant `default` to
    /// provide default implementation for the `Requestable.path()` method.
    /// ````
    /// func path() throws -> NetQuilt.URLPath {
    ///     return NetQuilt.URLPath.default
    /// }
    /// ````
    /// This approach allows the url path implementation to remain as an option
    /// requirement and yet when implemented by the client, validate the url path where
    /// the value is guaranteed to be valid or invalid.
    private init() {
        self.path = String()
    }
}

internal extension NetQuilt.URLPath {
    /// Provides the default implementation value for the `Requestable` protocol.
    static let `default` = NetQuilt.URLPath()
}
