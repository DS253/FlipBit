//
//  NSReqularExpression+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension NSRegularExpression {
    /// Returns a RFC compliant regex pattern for a URL host.
    static let urlHost: NSRegularExpression = {
        do {
            let pattern = "^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])(\\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9]))*$"
            
            return try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch { fatalError("Error initializing a valid NSRegularExpression instance given the provided pattern for URL host validation. Error: \(error)") }
    }()
    
    /// Returns a RFC compliant regex pattern for a URL path.
    static let urlPath: NSRegularExpression = {
        do {
            let pattern = "(^[/]((\\w.+)))+.(\\w)+"
            
            return try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch { fatalError("Error initializing a valid NSRegularExpression instance given the provided pattern for URL path validation. Error: \(error)") }
    }()
}
