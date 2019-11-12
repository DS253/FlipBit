//
//  NetQuiltError.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// List of all possible error cases thrown by `NetQuilt` framework.
///
/// By design, associated values are of a specific type (NSError vs Error).
/// In the implementation context, `JSONDecoder` and `URLSession` return
/// an instance of NSError.
///
/// Another benefit of using concrete types is the ability to conform them to the `Codable`
/// protocol and implement custom encoding / decoding. This is not possible if the
/// associated value is refered as Error - thus preventing types such as `NetQuiltError`
/// from becoming codable as well.
///
/// For more information on how to encode / decode Objective-C types, see `KeyedEncodingContainer`
/// and `KeyedDecodingContainer` extensions (they are no Codable by default).
public enum NetQuiltError: Error {
    /// Decoder failed to decode data.
    case decoder(NSError)
    
    /// Failed to initialize Data instance from `URL`.
    case data(NSError)
    
    /// Failed to initialize `URLRequest` with `Requestable` instance.
    case requestable(RequestableError)
    
    /// Service returned invalid response where the status code is not in `200...299` range.
    ///
    /// An optional response `data` will be set for further processing of the `body`.
    case response(NetQuilt.Response)
    
    /// URLSession failed with error.
    case session(NSError)
    
    /// Unexpected, logic error.
    case unexpected
    
    /// Unknown error occurred.
    ///
    /// As an example, this error is thrown when `URLSession` call fails without
    /// providing any meaningful data (ex: error, response, and data are `nil`).
    case unknown
}
