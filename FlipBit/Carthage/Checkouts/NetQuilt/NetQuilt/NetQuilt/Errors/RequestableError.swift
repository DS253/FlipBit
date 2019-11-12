//
//  RequestableError.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// List of possible error cases when a conversion from `Requestable` to `URLRequest` fails.
public enum RequestableError: String, Codable, Error {
    /// Base URL failed validation. Most probable cause is invalid URL host.
    case invalidBaseURL
    
    /// `URLComponents` initialization with provided URL string failed.
    case invalidURL
    
    /// URL path validation failed.
    case invalidURLPath
}
