//
//  NetQuilt+BaseURL.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// Model object representing a base URL composed from the URL scheme and host.
    struct BaseURL {
        /// The URL scheme as defined in RFC 2718.
        internal let scheme: NetQuilt.BaseURL.Scheme
        
        /// The URL host as defined in RFC 1738.
        internal let host: String
        
        /// List of supported scheme types.
        public enum Scheme {
            /// The hyper text transfer protocol.
            case http
            
            /// The hyper text transfer protocol secure.
            case https
        }
        
        /// Creates a `BaseURL` instance given the provided parameter(s).
        ///
        /// - Parameters:
        /// - scheme: The URL scheme as defined in RFC 2718.
        /// - host:   The URL host as defined in RFC 1738.
        ///
        /// - Throws: `RequestableError.invalidBaseURL` when URL host validation fails.
        public init(scheme: NetQuilt.BaseURL.Scheme = .https, host: String) throws {
            guard host.isValidURLHost else {
                throw RequestableError.invalidBaseURL
            }
            
            self.scheme = scheme
            self.host = host
        }
    }
}

// MARK: StringConvertible

extension NetQuilt.BaseURL: StringConvertible {
    var stringValue: String {
        return scheme.stringValue + host
    }
}

extension NetQuilt.BaseURL.Scheme: StringConvertible {
    var stringValue: String {
        switch self {
        case .http:
            return "http://"
        case .https:
            return "https://"
        }
    }
}
