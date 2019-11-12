//
//  Result+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/13/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension Result {
    /// Creates a `Result` instance given the provided parameter(s).
    ///
    /// - Parameters:
    ///   - failure: The error to initialize
    init(_ failure: Failure) {
        self = .failure(failure)
    }
    
    /// Creates a `Result` instance given the provided parameter(s).
    ///
    /// - Parameters:
    ///   - success: The value to initialize the success case with.
    init(_ success: Success) {
        self = .success(success)
    }
}

internal extension Result {
    /// Returns an optional error if the `Result` is Failure.
    var error: Failure? {
        guard case .failure(let error) = self else { return nil }
        
        return error
    }
    
    /// Returns an optional value if the `Result` is Success.
    var value: Success? {
        guard case .success(let value) = self else { return nil }
        
        return value
    }
    
    /// Returns an optional value if the `Result` is Success. Throws on error.
    func unwrap() throws -> Success? {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}