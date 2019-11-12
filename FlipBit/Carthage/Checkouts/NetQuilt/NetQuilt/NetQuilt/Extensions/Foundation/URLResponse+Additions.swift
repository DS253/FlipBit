//
//  URLResponse+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension URLResponse {
    /// Returns `true` if the status code of the `HTTPURLResponse` is not in `200...299` range.
    var isFailure: Bool {
        return !isSuccessful
    }
    
    /// Returns `true` if the status code of the `HTTPURLResponse` is not in `200...299` range.
    var isSuccessful: Bool {
        guard let response = self as? HTTPURLResponse else { return false }
        
        switch response.statusCode {
        case 200...299:
            return true
        default:
            return false
        }
    }
}
