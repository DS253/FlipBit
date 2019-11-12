//
//  NetQuilt+Method.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// List of available HTTP methods.
    enum Method: Equatable {
        /// Use for deleting a resource.
        case delete
        
        /// Use for reading/retrieving a representation of a resource.
        case get
        
        /// Use for modifying capabilities.
        case patch(Data)
        
        /// Use for creating new resources.
        case post(Data)
        
        /// Use for replacing a resource.
        case put(Data)
    }
}

// MARK: StringConvertible

extension NetQuilt.Method: StringConvertible {
    internal var stringValue: String {
        switch self {
        case .delete:
            return "DELETE"
        case .get:
            return "GET"
        case .patch:
            return "PATCH"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}

// MARK: Data

internal extension NetQuilt.Method {
    var body: Data? {
        switch self {
        case .delete, .get:
            return nil
        case .patch(let data), .post(let data), .put(let data):
            return data
        }
    }
}
