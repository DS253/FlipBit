//
//  BitService+Error.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    /// List of all possible error cases returned by `BitService` framework.
    enum Error: Swift.Error {
        /// Decoder failed to decode data.
        case decoder(NSError)
        
        /// A `BitService` internal error occurred due to misconfiguration.
        case `internal`
        
        /// Service returned invalid response where the status code is not in `200...299` range.
        ///
        /// An optional response `data` will be set for further processing of the `body`.
        /// `data` will contain the error message or the model object.
        ///
        /// For more information, see `BitService.Response`.
        case response(BitService.Response)
        
        /// An error occured within the networking library, or any other `BitService` dependency.
        case dependency
        
        /// Operation is not supported by `BitService`.
        case unsupportedOperation
        
        /// Creates a `BitService.Error` instance given the provided parameter(s).
        ///
        /// - Parameters:
        ///   - error: The `NetQuiltError` instance mapped to `BitService.Error`.
        internal init(_ error: NetQuiltError) {
            switch error {
            case .data, .requestable:
                self = .internal
            case .decoder(let error):
                self = .decoder(error)
            case .response(let response):
                self = .response(BitService.Response(response))
            case .session, .unexpected, .unknown:
                self = .dependency
            }
        }
    }
}


