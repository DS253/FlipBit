//
//  NetQuilt+NetSessionConfiguration.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// Model object of the NetSession Configuration.
    class NetSessionConfiguration {
        /// The configuration default value is `.ephemeral`.
        internal let configuration: NetQuilt.NetSessionConfiguration.Configuration
        
        /// The JSONDecoder for decoding data into models.
        internal let decoder: JSONDecoder
        
        /// The queue to dispatch `Result` object on.
        internal let dispatchQueue: DispatchQueue
        
        /// The standardized timeout interval for request and resource.
        internal let timeout: NetQuilt.NetSessionConfiguration.Timeout
        
        /// List of supported session configurations.
        ///
        /// The configuration enum is a represents the available options offered
        /// by Foundation as clas properties for `URLSessionConfiguration`.
        public enum Configuration: Equatable {
            /// A session configuration for transferring data files while the app runs in the background.
            case background(String)

            /// The default session configuration uses a persistent disk-based cache.
            case `default`

            /// Ephemeral configuration doesn’t store caches, credential stores, or any session-related data on disk (RAM only).
            case ephemeral
        }
        
        /// Creates a `NetSessionConfiguration` instance given the provided paramter(s).
        ///
        /// - Parameters:
        ///   - configuration: The `NetQuilt.NetSessionConfiguration` - default value is `.ephemeral`.
        ///   - decoder:       The `JSONDecoder` for decoding data into models.
        ///   - dispatchQueue: The queue to dispatch `Result` objects on.
        public init(configuration: NetQuilt.NetSessionConfiguration.Configuration = .ephemeral, decoder: JSONDecoder = JSONDecoder(), dispatchQueue: DispatchQueue = .main) {
            self.configuration = configuration
            self.decoder = decoder
            self.dispatchQueue = dispatchQueue
            self.timeout = Timeout()
        }
    }
}

// MARK: - Configuration

internal extension NetQuilt.NetSessionConfiguration {
    /// Returns `URLSessionConfiguration` for each `NetQuilt.NetSession.Configuration` case.
    var sessionConfiguration: URLSessionConfiguration {
        let sessionConfiguration: URLSessionConfiguration
        
        switch configuration {
        case .background(let identifier):
            sessionConfiguration = .background(withIdentifier: identifier)
        case .ephemeral:
            sessionConfiguration = .ephemeral
            
        case .default:
            sessionConfiguration = .default
        }
        
        sessionConfiguration.timeoutIntervalForRequest = timeout.request
        sessionConfiguration.timeoutIntervalForResource = timeout.resource
        
        return sessionConfiguration
    }
}
