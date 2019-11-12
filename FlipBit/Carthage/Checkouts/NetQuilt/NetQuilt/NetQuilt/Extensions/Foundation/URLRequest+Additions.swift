//
//  URLRequest+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension URLRequest {
    /// Creates a `URLRequest` instance given the provided parameter(s).
    ///
    /// - Parameters:
    ///  - requestable: The `Requestable` item containing all required data to initialize `self`.
    init(requestable: Requestable) throws {
        // Validate base URL, get a string value if validation succeeds.
        let baseURLString = try requestable.baseURL().stringValue
        
        // Validate URL path, get a string value if validation succeeds.
        let pathString = try requestable.path().stringValue
        
        // Add query parameters, if any.
        guard let url = URLComponents(baseURLString, path: pathString, queryItems: requestable.queryItems)?.url else {
            throw RequestableError.invalidURL
        }
        
        // Initialize `self`.
        self.init(url: url)
        
        // Set additional values.
        allHTTPHeaderFields = requestable.headerItems?.dictionary
        httpBody = requestable.method.body
        httpMethod = requestable.method.stringValue
    }
}
