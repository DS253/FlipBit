//
//  Requestable.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// Declares an interface used for initializing a network request object.
public protocol Requestable {
    /// An array of header items to apply to a `URLRequest`.
    var headerItems: [NetQuilt.HeaderItem]? { get }
    
    /// The HTTP method to apply to a `URLRequest`
    var method: NetQuilt.Method { get }
    
    /// The array of query items to apply to a URL.
    var queryItems: [NetQuilt.QueryItem]? { get }
    
    /// The base url to initialize `URLRequest` with.
    ///
    /// The URL host must begin and end with a word.
    ///
    /// ````
    /// func baseURL() throws -> NetQuilt.BaseURL {
    ///     return try NetQuilt.BaseURL(host: "api.example.net")
    /// }
    /// ````
    /// In the event that the provided URL host fails validation, the client will be notified
    /// at the time of a network call by receiving a `RequestbleError.invalidBaseURL` error.
    func baseURL() throws -> NetQuilt.BaseURL
    
    /// The URL path to append to a base URL.
    ///
    /// The path should begin with a forward slash `/` and end with a word.
    ///
    /// ````
    /// func path() throws -> NetQuilt.URLPath {
    ///     return try NetQuilt.URLPath("/path/to/resource")
    /// }
    /// ````
    /// In the event the provided URL path fails validation, the client will be notified
    /// at the time of a network call by receiving a `RequestableError.invalidURLPath` error.
    func path() throws -> NetQuilt.URLPath
}
